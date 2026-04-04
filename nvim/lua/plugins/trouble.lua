return {
  {
    "folke/trouble.nvim",
    lazy = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }

      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
        {silent = true, noremap = true}
      )

      -- Diagnostic signs
      -- https://github.com/folke/trouble.nvim/issues/52
      local signs = {
          Error = " ",
          Warning = " ",
          Hint = " ",
          Information = " "
      }
      for type, icon in pairs(signs) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
      end
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  },
}
