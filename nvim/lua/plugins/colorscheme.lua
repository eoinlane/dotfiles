-- Match the rest of the estate (Alacritty, tmux, Ghostty, Zed, Sublime):
-- Catppuccin Mocha instead of LazyVim's default tokyonight.
--
-- Markdown overrides below. Stock Catppuccin + render-markdown paint
-- RenderMarkdownH1, @markup.strong and @markup.italic all #f38ba8, so a heading,
-- a bold run and an italic run are the same colour and the page reads as one pink
-- wash. Headings now run a cool-to-warm scale by depth, bold is bright plain text
-- carrying the bold attribute, italic is lavender. Body text and comments are
-- lifted for contrast.

local heading = {
  { fg = "#89b4fa", bg = "#2b3046" }, -- H1 blue
  { fg = "#74c7ec", bg = "#283245" }, -- H2 sapphire
  { fg = "#94e2d5", bg = "#2c3642" }, -- H3 teal
  { fg = "#a6e3a1", bg = "#2e363c" }, -- H4 green
  { fg = "#f9e2af", bg = "#38363e" }, -- H5 yellow
  { fg = "#fab387", bg = "#383039" }, -- H6 peach
}

local function apply()
  local set = vim.api.nvim_set_hl
  for i, c in ipairs(heading) do
    set(0, "RenderMarkdownH" .. i, { fg = c.fg, bold = true })
    set(0, "RenderMarkdownH" .. i .. "Bg", { bg = c.bg })
    set(0, "@markup.heading." .. i .. ".markdown", { fg = c.fg, bold = true })
  end
  -- Emphasis stops competing with structure.
  set(0, "@markup.strong", { fg = "#f2f4fd", bold = true })
  set(0, "@markup.italic", { fg = "#b4befe", italic = true })
  -- Lift body text and comments off the background.
  set(0, "Normal", { fg = "#dee3f5", bg = "#1e1e2e" })
  set(0, "Comment", { fg = "#a6adc8", italic = true })
end

-- render-markdown defines its groups on setup, so re-apply after any colorscheme load.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("eoin_markdown_colors", { clear = true }),
  callback = function()
    vim.schedule(apply)
  end,
})

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = { flavour = "mocha" },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
