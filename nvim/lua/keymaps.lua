-- jj to escape insert mode
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true })

-- Twilight
vim.keymap.set('n', 'tw', ':Twilight<CR>', { noremap = true })

-- Buffer navigation
vim.keymap.set('n', 'tk', ':blast<CR>', { noremap = true })
vim.keymap.set('n', 'tj', ':bfirst<CR>', { noremap = true })
vim.keymap.set('n', 'th', ':bprev<CR>', { noremap = true })
vim.keymap.set('n', 'tl', ':bnext<CR>', { noremap = true })
vim.keymap.set('n', 'td', ':bdelete<CR>', { noremap = true })

-- File operations
vim.keymap.set('n', 'QQ', ':q!<CR>', { noremap = true })
vim.keymap.set('n', 'WW', ':w!<CR>', { noremap = true })

-- Motion shortcuts
vim.keymap.set('n', 'E', '$', { noremap = true })
vim.keymap.set('n', 'B', '^', { noremap = true })

-- Toggle transparent background
vim.keymap.set('n', 'TT', ':TransparentToggle<CR>', { noremap = true })

-- Clear search highlight
vim.keymap.set('n', 'ss', ':noh<CR>', { noremap = true })
vim.keymap.set('n', '<space><space>', '<cmd>set nohlsearch<CR>')

-- Split resize
vim.keymap.set('n', '<C-W>,', ':vertical resize -10<CR>', { noremap = true })
vim.keymap.set('n', '<C-W>.', ':vertical resize +10<CR>', { noremap = true })

-- Close split
vim.keymap.set('n', '<leader>qq', ':q<CR>', { silent = true, noremap = true })

-- Prevent space from doing anything at top level
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Better j/k for wrapped lines
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Dismiss Noice messages
vim.keymap.set('n', '<leader>nn', ':Noice dismiss<CR>', { noremap = true })

-- Go: insert error check
vim.keymap.set('n', '<leader>ee', '<cmd>GoIfErr<cr>', { silent = true, noremap = true })
