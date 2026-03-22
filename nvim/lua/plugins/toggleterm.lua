require('toggleterm').setup({
  size = function(term)
    if term.direction == 'horizontal' then
      return 15
    elseif term.direction == 'vertical' then
      return math.floor(vim.o.columns * 0.45)
    end
  end,
  open_mapping = [[<C-t>]],
  shade_terminals = false,
  direction = 'vertical',
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = 'curved',
    winblend = 3,
  },
})

-- Easy navigation out of terminal with Ctrl+hjkl
local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<CR>', opts)
  vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<CR>', opts)
  vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<CR>', opts)
  vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<CR>', opts)
  vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)
end

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = 'term://*toggleterm*',
  callback = set_terminal_keymaps,
})

-- Dedicated Claude terminal (terminal #2, always vertical)
local Terminal = require('toggleterm.terminal').Terminal

local claude = Terminal:new({
  cmd = 'claude',
  direction = 'vertical',
  id = 2,
  on_open = function(term)
    vim.cmd('startinsert!')
    vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<CR>', { buffer = term.bufnr })
    vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { buffer = term.bufnr })
  end,
})

vim.keymap.set('n', '<leader>tc', function() claude:toggle() end, { desc = 'Toggle Claude terminal' })
