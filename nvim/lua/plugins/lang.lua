return {
  -- Julia support
  {
    "JuliaEditorSupport/julia-vim",
    init = function()
      vim.g.latex_to_unicode_auto = 0
      vim.g.latex_to_unicode_file_types = ""
    end,
  },

  -- Julia LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        julials = {},
      },
    },
  },

  -- Treesitter: add julia parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "python", "julia" })
    end,
  },

  -- Lazygit
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
