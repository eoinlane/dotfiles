return {
  'rmagatti/auto-session',
  config = function()
    require('auto-session').setup({
      log_level = 'error',
      suppressed_dirs = { '~/', '~/Downloads', '/' },
      auto_restore_enabled = true,
      auto_save_enabled = true,
    })

    vim.keymap.set('n', '<leader>qs', '<cmd>SessionSave<cr>', { desc = 'Save session' })
    vim.keymap.set('n', '<leader>qr', '<cmd>SessionRestore<cr>', { desc = 'Restore session' })
  end,
}
