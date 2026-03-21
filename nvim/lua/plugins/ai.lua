require('codecompanion').setup({
  adapters = {
    anthropic = function()
      return require('codecompanion.adapters').extend('anthropic', {
        env = {
          api_key = 'ANTHROPIC_API_KEY',
        },
      })
    end,
  },
  strategies = {
    chat = { adapter = 'anthropic' },
    inline = { adapter = 'anthropic' },
    agent = { adapter = 'anthropic' },
  },
})

vim.keymap.set('n', '<leader>cc', '<cmd>CodeCompanionChat<cr>', { desc = 'CodeCompanion Chat' })
vim.keymap.set('v', '<leader>cc', '<cmd>CodeCompanionChat Add<cr>', { desc = 'Add to Chat' })
vim.keymap.set({ 'n', 'v' }, '<leader>ci', '<cmd>CodeCompanion<cr>', { desc = 'CodeCompanion Inline' })
vim.keymap.set('n', '<leader>cA', '<cmd>CodeCompanionActions<cr>', { desc = 'CodeCompanion Actions' })
