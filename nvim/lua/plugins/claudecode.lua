-- coder/claudecode.nvim — Claude Code integration for nvim (trialled &
-- kept 2026-07-01). Keys under <leader>a; see below.
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
