return {
  -- worktree
  {
    'ThePrimeagen/git-worktree.nvim',
    config = function()
      require('git-worktree').setup()
    end,
  },
  -- Comment
  {
    'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
    event = { "BufRead", "BufNewFile" },
    config = true,
  },
  -- Go
  {
    'ray-x/go.nvim',
    dependencies = { 'ray-x/guihua.lua' },
    config = function()
      require('go').setup()
    end,
  },
  -- Surround
  "tpope/vim-surround",
  -- Transparent background
  'xiyaowong/nvim-transparent',
  -- Indent guides
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  -- Catppuccin colorscheme
  { "catppuccin/nvim", as = "catppuccin" },
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  -- Notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",
        enabled = false,
      })
    end
  },
  -- Noice (UI for messages, cmdline, popupmenu)
  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        -- add any options here
        routes = {
          {
            filter = {
              event = 'msg_show',
              any = {
                { find = '%d+L, %d+B' },
                { find = '; after #%d+' },
                { find = '; before #%d+' },
                { find = '%d fewer lines' },
                { find = '%d more lines' },
              },
            },
            opts = { skip = true },
          }
        },
      })
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require("nvim-autopairs").setup {} end
  },
  -- Goto preview
  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {
        width = 120; -- Width of the floating window
        height = 15; -- Height of the floating window
        border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}; -- Border characters of the floating window
        default_mappings = true;
        debug = false; -- Print debug information
        opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false; -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
        references = { -- Configure the telescope UI for slowing the references cycling window.
          telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
        };
        -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
        focus_on_open = true; -- Focus the floating window when opening it.
        dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
        stack_floating_preview_windows = true, -- Whether to nest floating windows
        preview_window_title = { enable = true, position = "left" }, -- Whether
      }
    end
  },
  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    cond = function() return vim.fn.has('mac') == 1 and vim.fn.executable("node") == 1 end,
  },
  -- Vim pencil (writing mode)
  "preservim/vim-pencil",
  -- Render markdown
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown' },
    opts = {},
  },
}
