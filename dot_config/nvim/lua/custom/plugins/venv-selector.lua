return {
  'linux-cultist/venv-selector.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-telescope/telescope.nvim',
  },
  ft = 'python',
  opts = {
    name = { 'venv', '.venv', 'env', '.env' },
    auto_refresh = true,
  },
  keys = {
    { '<leader>av', '<cmd>VenvSelect<cr>', desc = 'Select Python venv' },
  },
}
