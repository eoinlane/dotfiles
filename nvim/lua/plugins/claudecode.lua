-- TRIAL (2026-07-01) — testing coder/claudecode.nvim. NOT committed to the repo
-- yet. If it stays, commit it; if not, delete this file + `:Lazy clean`.
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>",        desc = "Claude: toggle" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",   desc = "Claude: focus" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",    mode = "v", desc = "Claude: send selection" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude: accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Claude: deny diff" },
    },
  },
}
