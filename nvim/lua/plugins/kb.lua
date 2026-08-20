-- kb.nvim: the nvim front end for knowledgebase-pipeline. Keys under <leader>k.
--
-- The module lives in the secondbrain repo (nvim/lua/kb/init.lua), loaded here as a
-- local plugin. It runs on the machine that holds ~/knowledge_base + ~/query_graph.py
-- (the M3). On any other machine the commands exist but stop with a hint to run `sb`,
-- which opens the front end on the M3 over SSH. Single mode since 2026-08-20.
local sb = vim.fn.expand(vim.env.SECONDBRAIN or "~/Documents/secondbrain")
if vim.fn.isdirectory(sb .. "/nvim/lua/kb") == 0 then
  return {}
end

return {
  {
    "kb.nvim",
    dir = sb .. "/nvim",
    name = "kb.nvim",
    dependencies = {
      "folke/snacks.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    event = "VeryLazy",
    -- `sb` starts nvim with +KBHome, before VeryLazy fires; these load the plugin on demand.
    cmd = { "KBHome", "KBTriage", "KBBrief", "KBDossier", "KBPrep", "KBAsk", "KBDraft", "KBDeclan" },
    config = function()
      require("kb").setup()
    end,
    keys = {
      -- landing page: today's brief + the slip-zone queue
      { "<leader>kH", "<cmd>KBHome<cr>", desc = "KB: home (brief + triage)" },
      -- read / browse the KB
      { "<leader>kk", "<cmd>KB<cr>", desc = "KB: find file" },
      { "<leader>kg", "<cmd>KBGrep<cr>", desc = "KB: grep" },
      { "<leader>kP", "<cmd>KBPerson<cr>", desc = "KB: find person" },
      { "<leader>kt", "<cmd>KBTopic<cr>", desc = "KB: find topic" },
      { "<leader>km", "<cmd>KBMeeting<cr>", desc = "KB: find meeting" },
      -- query the graph
      { "<leader>kb", "<cmd>KBBrief<cr>", desc = "KB: daily brief" },
      { "<leader>kr", "<cmd>KBReview<cr>", desc = "KB: weekly review" },
      { "<leader>kS", "<cmd>KBStats<cr>", desc = "KB: graph stats" },
      { "<leader>ko", "<cmd>KBOpen<cr>", desc = "KB: open items" },
      -- The daily pass. Slip zone only (4+ days old); Enter closes, u undoes.
      { "<leader>kj", "<cmd>KBTriage<cr>", desc = "KB: triage slip zone" },
      { "<leader>kL", "<cmd>KBLearn<cr>", desc = "KB: what triage taught us" },
      { "<leader>kc", "<cmd>KBContext<cr>", desc = "KB: context (person)" },
      { "<leader>kp", "<cmd>KBPrep<cr>", desc = "KB: dossier + prep (person)" },
      { "<leader>kD", "<cmd>KBDossier<cr>", desc = "KB: dossier (person)" },
      { "<leader>kh", "<cmd>KBHistory<cr>", desc = "KB: history (person)" },
      { "<leader>ky", "<cmd>KBSynth<cr>", desc = "KB: synthesise (person)" },
      { "<leader>kd", "<cmd>KBDecisions<cr>", desc = "KB: decisions" },
      { "<leader>kT", "<cmd>KBTags<cr>", desc = "KB: tags" },
      { "<leader>kn", "<cmd>KBStale<cr>", desc = "KB: stale nudge" },
      { "<leader>kf", "<cmd>KBFocus<cr>", desc = "KB: focus list" },
      { "<leader>kx", "<cmd>KBDone<cr>", desc = "KB: mark done" },
      -- reason (Claude picks the query verbs itself, via kb-agent)
      { "<leader>ka", "<cmd>KBAsk<cr>", desc = "KB: ask (Claude over the graph)" },
      -- compose (email in Eoin's voice to the clipboard)
      { "<leader>ke", "<cmd>KBDraft<cr>", desc = "KB: draft email (Claude)" },
      { "<leader>kW", "<cmd>KBDeclan<cr>", desc = "KB: weekly Declan update (draft)" },
    },
  },
}
