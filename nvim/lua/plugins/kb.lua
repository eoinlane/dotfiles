-- kb.nvim — local (in-config) module; front end for the knowledgebase-pipeline.
-- Runs on this M1 Air, points at the DATA on the M3 Air (eoins-m3-air) over Tailscale:
--   READ  : ~/.cache/kb  ← rsync of M3:~/knowledge_base   (:KBSync / <leader>ks)
--   QUERY : ssh M3 python3 ~/query_graph.py <verb>        (live graph.db, single-writer)
-- Module: lua/kb/init.lua. Keys under <leader>k. See secondbrain/CLAUDE.md.
return {
  {
    "kb.nvim",
    dir = vim.fn.stdpath("config"),
    name = "kb.nvim",
    dependencies = {
      "folke/snacks.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    event = "VeryLazy",
    config = function()
      vim.g.kb_dir = vim.g.kb_dir or "~/.cache/kb"
      vim.g.kb_host = vim.g.kb_host or "eoin@100.103.128.44"
      vim.g.kb_remote = vim.g.kb_remote or "eoin@100.103.128.44:knowledge_base/"
      vim.g.kb_query = vim.g.kb_query or "~/query_graph.py"
      require("kb").setup()
    end,
    keys = {
      -- read / browse the mirror
      { "<leader>kk", "<cmd>KB<cr>", desc = "KB: find file" },
      { "<leader>kg", "<cmd>KBGrep<cr>", desc = "KB: grep" },
      { "<leader>kP", "<cmd>KBPerson<cr>", desc = "KB: find person" },
      { "<leader>kt", "<cmd>KBTopic<cr>", desc = "KB: find topic" },
      { "<leader>km", "<cmd>KBMeeting<cr>", desc = "KB: find meeting" },
      { "<leader>ks", "<cmd>KBSync<cr>", desc = "KB: sync from M3" },
      -- query the live graph (M3)
      { "<leader>kb", "<cmd>KBBrief<cr>", desc = "KB: daily brief" },
      { "<leader>kr", "<cmd>KBReview<cr>", desc = "KB: weekly review" },
      { "<leader>kS", "<cmd>KBStats<cr>", desc = "KB: graph stats" },
      { "<leader>ko", "<cmd>KBOpen<cr>", desc = "KB: open items" },
      { "<leader>kc", "<cmd>KBContext<cr>", desc = "KB: context (person)" },
      { "<leader>kp", "<cmd>KBPrep<cr>", desc = "KB: prep (person)" },
      { "<leader>kh", "<cmd>KBHistory<cr>", desc = "KB: history (person)" },
      { "<leader>ky", "<cmd>KBSynth<cr>", desc = "KB: synthesise (person)" },
      { "<leader>kd", "<cmd>KBDecisions<cr>", desc = "KB: decisions" },
      { "<leader>kT", "<cmd>KBTags<cr>", desc = "KB: tags" },
      { "<leader>kn", "<cmd>KBStale<cr>", desc = "KB: stale nudge" },
      { "<leader>kf", "<cmd>KBFocus<cr>", desc = "KB: focus list" },
      { "<leader>kx", "<cmd>KBDone<cr>", desc = "KB: mark done (writes M3)" },
    },
  },
}
