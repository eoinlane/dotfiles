-- kb: front end for the knowledgebase-pipeline, running on the M1 Air but pointed
-- at the DATA on the M3 Air (eoins-m3-air) over Tailscale. Verified 2026-07-02.
--
-- The M3 is the primary/authoritative machine:
--   * ~/knowledge_base   — 2,691 markdown notes with [[wikilinks]] (built here nightly)
--   * ~/query_graph.py   — the live query layer over ~/graph.db (single-writer)
--   * ~/graph.db         — the knowledge graph (action items, decisions, 30k+ edges)
--
-- Two seams from this M1:
--   * READ  — a one-way rsync mirror of ~/knowledge_base into ~/.cache/kb, for fast
--             local fuzzy-find / grep / render / wikilink nav. Refresh with :KBSync.
--             Read-only cache; we never write back to it.
--   * QUERY — SSH-exec `python3 ~/query_graph.py <verb>` on the M3, stdout piped into a
--             render-markdown scratch buffer. `done` is the sole write path and mutates
--             graph.db on the M3 only (single-writer preserved).
--
-- Override defaults with vim.g.kb_dir / vim.g.kb_host / vim.g.kb_remote / vim.g.kb_query.

local M = {}

M.config = {
  dir = "~/.cache/kb", -- local read mirror
  host = "eoin@100.103.128.44", -- M3 over Tailscale (MagicDNS off; use tailnet IP)
  remote = "eoin@100.103.128.44:knowledge_base/", -- rsync source
  query = "~/query_graph.py", -- query_graph.py on the M3
}

-- ---------------------------------------------------------------------------
-- helpers
-- ---------------------------------------------------------------------------

local function kb_dir()
  return vim.fn.expand(M.config.dir)
end

local function have_dir()
  if vim.fn.isdirectory(kb_dir()) == 0 then
    vim.notify("kb: mirror not found: " .. M.config.dir .. " — run :KBSync.", vim.log.levels.WARN)
    return false
  end
  return true
end

-- POSIX single-quote escape (safe for both bash and the M3's fish login shell).
local function shq(s)
  return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end

-- Open text in a throwaway markdown buffer so render-markdown.nvim styles it.
local function open_scratch(title, lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"
  pcall(vim.api.nvim_buf_set_name, buf, "kb://" .. title)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.cmd("botright vsplit")
  vim.api.nvim_win_set_buf(0, buf)
  -- <leader>kx closes the action item on the current line (needs a #id, which
  -- :KBOpen emits). Buffer-local so it only fires inside these kb:// lists.
  vim.keymap.set("n", "<leader>kx", function() M.done_line() end,
    { buffer = buf, desc = "KB: close item on this line" })
  return buf
end

-- Build the query command. On the primary M3 (is_local) run query_graph.py
-- directly; from a satellite (M1) SSH-exec it on the M3. Same module, both roles.
local function query_cmd(verb, args)
  if M.config.is_local then
    local cmd = { "python3", vim.fn.expand(M.config.query), verb }
    for _, a in ipairs(args or {}) do
      cmd[#cmd + 1] = tostring(a)
    end
    return cmd
  end
  local remote = "python3 " .. M.config.query .. " " .. verb
  for _, a in ipairs(args or {}) do
    remote = remote .. " " .. shq(a)
  end
  return { "ssh", "-o", "ConnectTimeout=10", "-o", "BatchMode=yes", M.config.host, remote }
end

-- Run `query_graph.py <verb> <args...>`; stream stdout to a scratch buffer.
local function run_query(title, verb, args)
  vim.notify("kb: " .. verb .. (args and #args > 0 and (" " .. table.concat(args, " ")) or "") .. " …", vim.log.levels.INFO)
  vim.system(query_cmd(verb, args), { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        vim.notify(("kb: `%s` failed (exit %d)\n%s"):format(verb, res.code, res.stderr or ""), vim.log.levels.ERROR)
        return
      end
      local out = res.stdout or ""
      open_scratch(title, vim.split(out ~= "" and out or "_(no output)_", "\n", { plain = true }))
    end)
  end)
end

-- Use the command arg if given, else prompt for it.
local function arg_or_prompt(arg, prompt, cb)
  if arg and arg ~= "" then
    cb(arg)
  else
    vim.ui.input({ prompt = prompt }, function(v)
      if v and v ~= "" then
        cb(v)
      end
    end)
  end
end

-- ---------------------------------------------------------------------------
-- READ seam — local mirror (snacks.picker)
-- ---------------------------------------------------------------------------

local function pick_files(sub, title)
  if not have_dir() then
    return
  end
  Snacks.picker.files({ cwd = sub and (kb_dir() .. "/" .. sub) or kb_dir(), title = title })
end

function M.files() pick_files(nil, "KB files") end
function M.people() pick_files("people", "KB people") end
function M.topics() pick_files("topics", "KB topics") end
function M.meetings() pick_files("meetings", "KB meetings") end

function M.grep()
  if not have_dir() then return end
  Snacks.picker.grep({ cwd = kb_dir(), title = "KB grep" })
end

-- Resolve [[target|alias]] / [[target#heading]] under the cursor to a file in the mirror.
function M.follow_wikilink()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".")
  local i = 1
  while true do
    local s, e = line:find("%[%[.-%]%]", i)
    if not s then break end
    if col >= s and col <= e then
      local target = line:sub(s + 2, e - 2):gsub("|.*$", ""):gsub("#.*$", "")
      target = vim.trim(target)
      if not target:match("%.md$") then target = target .. ".md" end
      local direct = kb_dir() .. "/" .. target
      if vim.fn.filereadable(direct) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(direct))
        return
      end
      local base = vim.fn.fnamemodify(target, ":t")
      local hits = vim.fn.glob(kb_dir() .. "/**/" .. base, false, true)
      if #hits == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(hits[1]))
      elseif #hits > 1 then
        Snacks.picker.files({ cwd = kb_dir(), title = "wikilink: " .. base })
      else
        vim.notify("kb: no file for [[" .. target .. "]]", vim.log.levels.WARN)
      end
      return
    end
    i = e + 1
  end
  vim.notify("kb: no [[wikilink]] under cursor", vim.log.levels.INFO)
end

function M.sync()
  if M.config.is_local then
    vim.notify("kb: on the primary (M3) — KB is local, no sync needed", vim.log.levels.INFO)
    return
  end
  local dest = kb_dir()
  vim.fn.mkdir(dest, "p")
  local cmd = {
    "rsync", "-az", "--delete", "--exclude", ".DS_Store", "--exclude", ".obsidian",
    "-e", "ssh -o ConnectTimeout=10 -o BatchMode=yes",
    M.config.remote, dest .. "/",
  }
  vim.notify("kb: syncing from M3 …", vim.log.levels.INFO)
  vim.system(cmd, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        vim.notify("kb: sync failed (exit " .. res.code .. ")\n" .. (res.stderr or ""), vim.log.levels.ERROR)
        return
      end
      vim.cmd("silent! checktime")
      vim.notify("kb: sync complete", vim.log.levels.INFO)
    end)
  end)
end

-- ---------------------------------------------------------------------------
-- QUERY seam — query_graph.py over SSH (live graph)
-- ---------------------------------------------------------------------------

function M.brief() run_query("brief", "brief", {}) end
function M.review() run_query("review", "review", { "--full" }) end
function M.stats() run_query("stats", "stats", {}) end
function M.decisions() run_query("decisions", "decisions", {}) end
function M.tags(q)
  arg_or_prompt(q, "Tag search (blank = all): ", function(v) run_query("tags:" .. v, "tags", { v }) end)
end
function M.focus() run_query("focus", "focus", {}) end
function M.stale() run_query("stale-nudge", "stale-nudge", {}) end

function M.open(proj)
  if proj and proj ~= "" then
    run_query("open:" .. proj, "open", { "--project", proj, "--ids" })
  else
    run_query("open", "open", { "--ids" })
  end
end
function M.prep(name)
  arg_or_prompt(name, "Prep for person: ", function(v) run_query("prep:" .. v, "prep", { v }) end)
end
function M.context(name)
  arg_or_prompt(name, "Context for person: ", function(v) run_query("context:" .. v, "context", { v }) end)
end
function M.history(name)
  arg_or_prompt(name, "History with person: ", function(v) run_query("history:" .. v, "history", { v }) end)
end
function M.synth(name)
  arg_or_prompt(name, "Synthesise person: ", function(v) run_query("synthesise:" .. v, "synthesise", { v }) end)
end

-- WRITE path — mutates graph.db. Confirm first.
function M.done(target)
  arg_or_prompt(target, "Close item (id or search text): ", function(v)
    local ok = vim.fn.confirm("Mark done in the graph:\n  " .. v .. "\nProceed?", "&Yes\n&No", 2)
    if ok == 1 then
      run_query("done:" .. v, "done", { v })
    end
  end)
end

-- Interactive close: grab the #id the list emits (:KBOpen --ids), close it in
-- the graph, and tick the line in place. Bound to <leader>kx inside kb:// lists.
function M.done_line()
  local line = vim.api.nvim_get_current_line()
  local id = line:match("#(%d+)")
  if not id then
    vim.notify("kb: no #id on this line — open the list with :KBOpen (it adds ids)", vim.log.levels.WARN)
    return
  end
  if vim.fn.confirm("Close item #" .. id .. " in the graph?", "&Yes\n&No", 2) ~= 1 then
    return
  end
  local buf = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.system(query_cmd("done", { id }), { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        vim.notify(("kb: close #%s failed\n%s"):format(id, res.stderr or ""), vim.log.levels.ERROR)
        return
      end
      -- tick the line as feedback (buffer is non-modifiable)
      local was = vim.bo[buf].modifiable
      vim.bo[buf].modifiable = true
      vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { (line:gsub("%[ %]", "[x]", 1)) })
      vim.bo[buf].modifiable = was
      vim.notify("kb: closed #" .. id, vim.log.levels.INFO)
    end)
  end)
end

-- ---------------------------------------------------------------------------
-- setup
-- ---------------------------------------------------------------------------

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  M.config.dir = vim.g.kb_dir or M.config.dir
  M.config.host = vim.g.kb_host or M.config.host
  M.config.remote = vim.g.kb_remote or M.config.remote
  M.config.query = vim.g.kb_query or M.config.query

  -- Detect role: on the primary M3 the KB + query layer are local, so run
  -- query_graph.py directly and read the KB in place; from a satellite (M1)
  -- fall through to the SSH/rsync seam. Override with vim.g.kb_local.
  if vim.g.kb_local ~= nil then
    M.config.is_local = vim.g.kb_local
  elseif M.config.is_local == nil then
    M.config.is_local = vim.fn.filereadable(vim.fn.expand(M.config.query)) == 1
      and vim.fn.isdirectory(vim.fn.expand("~/knowledge_base")) == 1
  end
  if M.config.is_local then
    M.config.dir = "~/knowledge_base" -- primary reads its own KB in place, no mirror
  end

  local c = vim.api.nvim_create_user_command
  -- read
  c("KB", M.files, { desc = "KB: find file" })
  c("KBGrep", M.grep, { desc = "KB: grep contents" })
  c("KBPerson", M.people, { desc = "KB: find person" })
  c("KBTopic", M.topics, { desc = "KB: find topic" })
  c("KBMeeting", M.meetings, { desc = "KB: find meeting" })
  c("KBSync", M.sync, { desc = "KB: rsync pull from M3" })
  c("KBFollow", M.follow_wikilink, { desc = "KB: follow [[wikilink]]" })
  -- query (live graph on M3)
  c("KBBrief", M.brief, { desc = "KB: daily brief" })
  c("KBReview", M.review, { desc = "KB: weekly review" })
  c("KBStats", M.stats, { desc = "KB: graph stats" })
  c("KBDecisions", M.decisions, { desc = "KB: decisions" })
  c("KBFocus", M.focus, { desc = "KB: focus list" })
  c("KBStale", M.stale, { desc = "KB: stale-commitment nudge" })
  c("KBOpen", function(a) M.open(a.args) end, { nargs = "?", desc = "KB: open items [project]" })
  c("KBPrep", function(a) M.prep(a.args) end, { nargs = "?", desc = "KB: prep [person]" })
  c("KBContext", function(a) M.context(a.args) end, { nargs = "?", desc = "KB: context [person]" })
  c("KBHistory", function(a) M.history(a.args) end, { nargs = "?", desc = "KB: history [person]" })
  c("KBSynth", function(a) M.synth(a.args) end, { nargs = "?", desc = "KB: synthesise [person]" })
  c("KBTags", function(a) M.tags(a.args) end, { nargs = "?", desc = "KB: tags [search]" })
  c("KBDone", function(a) M.done(a.args) end, { nargs = "?", desc = "KB: mark done [id] (writes M3)" })

  -- buffer-local wikilink follow inside the mirror
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("kb_wikilinks", { clear = true }),
    pattern = kb_dir() .. "/*.md",
    callback = function(ev)
      vim.keymap.set("n", "gf", M.follow_wikilink, { buffer = ev.buf, desc = "KB: follow wikilink" })
      vim.keymap.set("n", "<CR>", M.follow_wikilink, { buffer = ev.buf, desc = "KB: follow wikilink" })
    end,
  })
end

return M
