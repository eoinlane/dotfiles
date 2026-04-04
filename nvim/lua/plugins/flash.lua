return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  config = function()
    require('flash').setup()

    vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash jump' })
    vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash treesitter' })
    vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote flash' })
    vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, { desc = 'Treesitter search' })
  end,
}
