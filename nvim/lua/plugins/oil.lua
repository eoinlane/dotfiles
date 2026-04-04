return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup({
      default_file_explorer = true,
      columns = { 'icon' },
      keymaps = {
        ['<C-h>'] = false,
        ['<C-l>'] = false,
      },
      view_options = {
        show_hidden = true,
      },
    })

    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    vim.keymap.set('n', '<leader>-', '<CMD>Oil --float<CR>', { desc = 'Open parent directory (float)' })
  end,
}
