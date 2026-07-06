-- Claude Code <-> nvim integration (M3 front end).
-- Built 2026-07-06. Removes the hand-cranked friction from driving nvim over RPC:
--   1. Fixed RPC socket   — tools reach this nvim at a known path (no lsof guessing).
--   2. Live auto-reload   — buffers Claude edits on disk refresh without manual :checktime.
--   3. Scratch lint-off   — diagnostics silenced on generated / scratch markdown.
-- Idempotent: safe to re-source (e.g. :luafile) into a running instance.

-- 1. Fixed server socket -----------------------------------------------------
local sock = vim.fn.stdpath("cache") .. "/server.sock"
if not vim.tbl_contains(vim.fn.serverlist(), sock) then
  pcall(vim.fn.serverstart, sock) -- pcall: another nvim may already hold it
end

-- 2. Auto-reload buffers changed on disk -------------------------------------
-- LazyVim only :checktime's on FocusGained, which never fires while you stay in
-- nvim as Claude edits files in another terminal. Add CursorHold + a 1s backstop
-- timer so external edits appear within ~1s.
vim.opt.autoread = true
local grp = vim.api.nvim_create_augroup("claude_autoreload", { clear = true })
local function safe_checktime()
  if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
    pcall(vim.cmd, "checktime")
  end
end
vim.api.nvim_create_autocmd(
  { "CursorHold", "CursorHoldI", "FocusGained", "BufEnter", "TermLeave" },
  { group = grp, callback = safe_checktime }
)
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = grp,
  callback = function()
    vim.notify("reloaded (changed on disk)", vim.log.levels.INFO, { title = "claude" })
  end,
})
-- repeating backstop timer; stop any prior one so re-sourcing doesn't stack timers
if _G.__claude_reload_timer then
  pcall(function()
    _G.__claude_reload_timer:stop()
    _G.__claude_reload_timer:close()
  end)
end
local timer = (vim.uv or vim.loop).new_timer()
if timer then
  timer:start(1000, 1000, vim.schedule_wrap(safe_checktime))
  _G.__claude_reload_timer = timer
end

-- 3. Diagnostics off for scratch / generated markdown ------------------------
-- Briefings, notes and email drafts Claude generates live under scratch dirs;
-- markdownlint noise (MD022/MD012...) just clutters them.
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = grp,
  pattern = { "*.md", "*.markdown" },
  callback = function(ev)
    local name = vim.api.nvim_buf_get_name(ev.buf)
    if name:match("/scratchpad/") or name:match("^/private/tmp/claude%-") or name:match("^/tmp/") then
      vim.schedule(function()
        pcall(vim.diagnostic.enable, false, { bufnr = ev.buf })
      end)
    end
  end,
})
