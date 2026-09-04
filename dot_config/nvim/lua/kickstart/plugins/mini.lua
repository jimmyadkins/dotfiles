return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- Cache staged diff counts (refreshed async on file events)
      local _staged = { added = 0, removed = 0 }

      local function refresh_staged()
        vim.fn.jobstart('git diff --cached --numstat 2>/dev/null', {
          stdout_buffered = true,
          on_stdout = function(_, data)
            local a, r = 0, 0
            for _, line in ipairs(data or {}) do
              local la, lr = line:match('^(%d+)%s+(%d+)')
              if la then
                a = a + tonumber(la)
                r = r + tonumber(lr)
              end
            end
            _staged = { added = a, removed = r }
            vim.schedule(vim.cmd.redrawstatus)
          end,
        })
      end

      vim.api.nvim_create_autocmd({ 'BufWritePost', 'FocusGained', 'BufEnter', 'ShellCmdPost' }, {
        group = vim.api.nvim_create_augroup('MiniStatuslineStaged', { clear = true }),
        callback = refresh_staged,
      })

      -- Read Claude model from ~/.claude/settings.json (cached until restart)
      local _claude_model = nil
      local function get_claude_model()
        if _claude_model then return _claude_model end
        local ok, lines = pcall(vim.fn.readfile, vim.env.HOME .. '/.claude/settings.json')
        if ok and lines then
          local jok, cfg = pcall(vim.fn.json_decode, table.concat(lines, ''))
          if jok and cfg and cfg.model then
            _claude_model = cfg.model
            return _claude_model
          end
        end
        _claude_model = 'claude'
        return _claude_model
      end

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.active = function()
        local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
        local branch = vim.b.gitsigns_head or ''
        local bufname = vim.api.nvim_buf_get_name(0)
        local rel = vim.fn.fnamemodify(bufname, ':~:.')
        if rel == '' then rel = '[No Name]' end
        local modified = vim.bo.modified and ' [+]' or ''
        local win_width = vim.fn.winwidth(0)

        local filename
        if win_width < 60 then
          filename = vim.fn.fnamemodify(bufname, ':t') .. modified
        elseif win_width < 100 then
          filename = vim.fn.pathshorten(rel) .. modified
        else
          filename = rel .. modified
        end

        -- Unstaged diff counts from gitsigns
        local gs = vim.b.gitsigns_status_dict or {}
        local unstaged = {}
        if (gs.added or 0) > 0 then table.insert(unstaged, '+' .. gs.added) end
        if (gs.changed or 0) > 0 then table.insert(unstaged, '~' .. gs.changed) end
        if (gs.removed or 0) > 0 then table.insert(unstaged, '-' .. gs.removed) end

        -- Staged diff counts (async cached)
        local staged = {}
        if _staged.added > 0 then table.insert(staged, '●+' .. _staged.added) end
        if _staged.removed > 0 then table.insert(staged, '●-' .. _staged.removed) end

        -- Current working directory (shortened to fit)
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')

        -- Claude connection status + model
        local claude_ok, claudecode = pcall(require, 'claudecode')
        local claude_info = ''
        if claude_ok then
          local connected = claudecode.is_claude_connected and claudecode.is_claude_connected()
          local model = get_claude_model()
          claude_info = (connected and '● ' or '○ ') .. model
        end

        -- Optional conversation header: set with  :lua vim.g.claude_header = "my session"
        local header = vim.g.claude_header and ('{' .. vim.g.claude_header .. '} ') or ''

        return statusline.combine_groups {
          { hl = mode_hl, strings = { mode } },
          { hl = 'MiniStatuslineDevinfo', strings = { branch, table.concat(unstaged, ' '), table.concat(staged, ' ') } },
          '%<',
          { hl = 'MiniStatuslineFilename', strings = { header .. cwd, filename } },
          '%=',
          { hl = 'MiniStatuslineFileinfo', strings = { claude_info } },
        }
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
