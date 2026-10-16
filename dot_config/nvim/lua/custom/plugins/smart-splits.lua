return {
  'mrjones2014/smart-splits.nvim',
  lazy = false, -- Must set @pane-is-vim on startup so tmux's Alt+hjkl bindings can see it
  config = function()
    local splits = require('smart-splits')

    splits.setup({
      at_edge = function(ctx)
        -- Nvim at edge: move to the next mux pane if there is one, else stay put
        if ctx.mux and not ctx.mux.current_pane_at_edge(ctx.direction) then
          ctx.mux.next_pane(ctx.direction)
        end
      end,
    })

    -- Persistent resize mode function
    local function resize_mode()
      local msg = '󰨊 RESIZE MODE: h/j/k/l (small) | H/J/K/L (large) | Esc/q (exit)'
      vim.api.nvim_echo({{msg, 'MoreMsg'}}, false, {})

      while true do
        local ok, char = pcall(vim.fn.getcharstr)
        if not ok then break end

        local resized = false
        if char == 'h' then
          splits.resize_left()
          resized = true
        elseif char == 'j' then
          splits.resize_down()
          resized = true
        elseif char == 'k' then
          splits.resize_up()
          resized = true
        elseif char == 'l' then
          splits.resize_right()
          resized = true
        elseif char == 'H' then
          splits.resize_left(10)
          resized = true
        elseif char == 'J' then
          splits.resize_down(5)
          resized = true
        elseif char == 'K' then
          splits.resize_up(5)
          resized = true
        elseif char == 'L' then
          splits.resize_right(10)
          resized = true
        elseif char == '\27' or char == 'q' then  -- Esc or q
          break
        end

        -- Force screen redraw to show resize immediately
        if resized then
          vim.cmd('redraw')
        end

        vim.api.nvim_echo({{msg, 'MoreMsg'}}, false, {})
      end

      vim.api.nvim_echo({{'', 'Normal'}}, false, {})
    end

    vim.keymap.set('n', '<M-h>', splits.move_cursor_left, { desc = 'Move to left split/pane/window' })
    vim.keymap.set('n', '<M-j>', splits.move_cursor_down, { desc = 'Move to below split/pane/window' })
    vim.keymap.set('n', '<M-k>', splits.move_cursor_up, { desc = 'Move to above split/pane/window' })
    vim.keymap.set('n', '<M-l>', splits.move_cursor_right, { desc = 'Move to right split/pane/window' })

    -- Terminal mode mappings for Claude Code and other terminal buffers
    vim.keymap.set('t', '<M-h>', splits.move_cursor_left, { desc = 'Move to left split/pane/window' })
    vim.keymap.set('t', '<M-j>', splits.move_cursor_down, { desc = 'Move to below split/pane/window' })
    vim.keymap.set('t', '<M-k>', splits.move_cursor_up, { desc = 'Move to above split/pane/window' })
    vim.keymap.set('t', '<M-l>', splits.move_cursor_right, { desc = 'Move to right split/pane/window' })

    -- Enter persistent resize mode with <leader>pr
    vim.keymap.set('n', '<leader>pr', resize_mode, { desc = 'Enter resize mode (h/j/k/l or H/J/K/L)' })
  end,
}
