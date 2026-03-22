local ok, alpha = pcall(require, 'alpha')
if not ok then return end
local dashboard = require('alpha.themes.dashboard')

dashboard.section.header.val = {
  "                                                     ",
  "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
  "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
  "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
  "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
  "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
  "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
  "                                                     ",
}

dashboard.section.buttons.val = {
  dashboard.button("f", "  Find file",       "<cmd>Telescope find_files<CR>"),
  dashboard.button("r", "  Recent files",    "<cmd>Telescope oldfiles<CR>"),
  dashboard.button("g", "  Live grep",       "<cmd>Telescope live_grep<CR>"),
  dashboard.button("n", "  New file",        "<cmd>ene <BAR> startinsert<CR>"),
  dashboard.button("l", "  Lazy",            "<cmd>Lazy<CR>"),
  dashboard.button("q", "  Quit",            "<cmd>qa<CR>"),
}

dashboard.section.footer.val = function()
  local stats = require("lazy").stats()
  return "  " .. stats.count .. " plugins loaded"
end

dashboard.config.opts.noautocmd = true

alpha.setup(dashboard.config)
