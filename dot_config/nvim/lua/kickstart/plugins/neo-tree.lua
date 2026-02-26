-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    use_icons = false,
    git_status_async = true,
    sources = { 'filesystem', 'git_status' },
    default_component_configs = {
      git_status = {
        symbols = {
          added     = 'A',
          modified  = 'M',
          deleted   = 'D',
          renamed   = 'R',
          untracked = '?',
          ignored   = 'I',
          unstaged  = 'U',
          staged    = 'S',
          conflict  = 'C',
        },
      },
    },
    filesystem = {
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_gitignored = false,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['.'] = 'set_root',
        },
      },
    },
  },
}
