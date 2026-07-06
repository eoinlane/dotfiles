-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Toggle the Claude Code pane (the `sb`-style `:terminal claude`): hide it if
-- visible (session keeps running), re-show it if hidden, or create one if none
-- exists. Mapped to <leader>cc.
local function toggle_claude()
  local cbuf
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b)
      and vim.bo[b].buftype == "terminal"
      and vim.api.nvim_buf_get_name(b):match("claude")
    then
      cbuf = b
      break
    end
  end
  if cbuf then
    for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_buf(w) == cbuf then
        pcall(vim.api.nvim_win_close, w, false) -- visible -> hide (job persists)
        return
      end
    end
    vim.cmd("botright vsplit") -- exists but hidden -> re-show it
    vim.api.nvim_win_set_buf(0, cbuf)
    vim.cmd("startinsert")
    return
  end
  vim.cmd("botright vsplit | terminal claude") -- none -> create a fresh one
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>cc", toggle_claude, { desc = "Toggle Claude pane" })
