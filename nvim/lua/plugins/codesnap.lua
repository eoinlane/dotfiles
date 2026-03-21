if vim.fn.has('mac') == 0 then return end

require("codesnap").setup({
  border = "rounded",
  has_breadcrumbs = true,
  bg_theme = "grape",
  watermark = ""
})
