-- Match the rest of the estate (Alacritty, tmux, Ghostty, Zed, Sublime):
-- Catppuccin Mocha instead of LazyVim's default tokyonight.
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
