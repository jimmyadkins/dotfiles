return {
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    open_mapping = [[<M-t>]],
    direction = 'float',
    float_opts = { border = 'rounded' },
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)

    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = 'lazygit',
      direction = 'float',
      float_opts = { border = 'rounded' },
      hidden = true,
    })

    vim.keymap.set('n', '<leader>gg', function()
      lazygit:toggle()
    end, { desc = 'Toggle lazygit' })
  end,
}
