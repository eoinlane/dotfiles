-- Diagnostics were rendering as virtual text trailing off the right edge of every
-- offending line, which buries the prose you are actually reading. nvim 0.11 can show
-- the full message under the cursor line only, so the gutter sign tells you a line has
-- a problem and the text appears when you move to it.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        virtual_lines = { current_line = true },
        signs = true,
        underline = true,
        severity_sort = true,
      },
    },
  },
}
