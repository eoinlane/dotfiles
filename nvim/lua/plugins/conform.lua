return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'goimports', 'gofmt' },
        python = { 'black' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        json = { 'prettier' },
        markdown = { 'prettier' },
        sh = { 'shfmt' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })

    vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
      require('conform').format({ async = true, lsp_fallback = true })
    end, { desc = 'Format buffer' })
  end,
}
