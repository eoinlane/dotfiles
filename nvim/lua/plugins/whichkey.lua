require('which-key').setup({
  delay = 500,
})

require('which-key').add({
  { '<leader>s', group = 'Search' },
  { '<leader>w', group = 'Workspace' },
  { '<leader>d', group = 'Document' },
  { '<leader>c', group = 'Code / AI' },
  { '<leader>h', group = 'Harpoon' },
  { '<leader>q', group = 'Session / Quit' },
})
