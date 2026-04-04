return {
  "mistricky/codesnap.nvim",
  build = "make",
  cond = function() return vim.fn.has('mac') == 1 end,
  config = function()
    require("codesnap").setup({
      border = "rounded",
      has_breadcrumbs = true,
      bg_theme = "grape",
      watermark = ""
    })
  end,
}
