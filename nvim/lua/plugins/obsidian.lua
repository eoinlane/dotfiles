local vault = vim.fn.expand("~/Dropbox/vaults/personal")

if vim.fn.isdirectory(vault) == 1 then
  require("obsidian").setup({
    workspaces = {
      {
        name = "Notes",
        path = vault,
      },
    },
  })
end
