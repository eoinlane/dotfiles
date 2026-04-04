# dotfiles

Personal configuration for macOS, Ubuntu, and FreeBSD.

## Contents

- **`fish/config.fish`** — Fish shell config with Starship prompt and git abbreviations
- **`nvim/`** — Neovim configuration (lazy.nvim, LSP, Go, AI, and more)
- **`zellij/`** — Zellij terminal multiplexer config (catppuccin-mocha theme, vim-style keybinds)
- **`bootstrap.sh`** — One-command install script

## Quick Start

```bash
git clone https://github.com/eoinlane/dotfiles ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

The bootstrap script will:
1. Install [fish](https://fishshell.com/) via the appropriate package manager
2. Install [Starship](https://starship.rs/) prompt
3. Symlink `fish/config.fish` to `~/.config/fish/config.fish`
4. Symlink `nvim/` to `~/.config/nvim`
5. Install and symlink [zellij](https://zellij.dev/) terminal multiplexer
6. Set fish as your default shell

Then open Neovim and run `:Lazy sync` to install all plugins.

## Neovim

Requires Neovim 0.9+. Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim).

### Plugins

| Category | Plugin | Purpose |
|----------|--------|---------|
| **AI** | codecompanion.nvim | Claude-powered chat + inline edits (`<leader>cc`) |
| **Files** | oil.nvim | Edit filesystem like a buffer (`-`) |
| **Navigation** | flash.nvim | 2-char jump motions (`s`) |
| **Navigation** | harpoon2 | File bookmarks (`<leader>m`) |
| **Navigation** | telescope.nvim | Fuzzy finder (`<leader>sf`, `<leader>sg`) |
| **LSP** | nvim-lspconfig + mason | Auto-install language servers |
| **Formatting** | conform.nvim | Format on save (Go, Lua, Python, JS, etc.) |
| **Git** | neogit + gitsigns + diffview | Full git workflow |
| **Go** | go.nvim + nvim-dap-go | Go dev + debugging |
| **Writing** | obsidian.nvim + zen-mode | Obsidian vault + distraction-free mode |
| **UI** | which-key.nvim | Keymap discovery popup |
| **UI** | noice.nvim + lualine | Better UI + statusline |
| **Sessions** | auto-session | Auto save/restore sessions per directory |

### Key bindings (highlights)

| Key | Action |
|-----|--------|
| `-` | Open oil (file browser) |
| `s` | Flash jump |
| `<leader>cc` | CodeCompanion chat |
| `<leader>ci` | CodeCompanion inline |
| `<leader>sf` | Telescope: find files |
| `<leader>sg` | Telescope: live grep |
| `<leader>m` | Harpoon: add file |
| `<leader>ht` | Harpoon: toggle menu |
| `<leader>cf` | Format buffer |
| `jj` | Exit insert mode |

### CodeCompanion setup

Set your Anthropic API key in your environment:

```bash
export ANTHROPIC_API_KEY=your_key_here
```

## Platform support

| OS      | Package manager |
|---------|----------------|
| macOS   | Homebrew        |
| Ubuntu  | apt             |
| FreeBSD | pkg             |

## Fish abbreviations

| Abbr      | Expands to                              |
|-----------|-----------------------------------------|
| `g`       | `git`                                   |
| `gs`      | `git status`                            |
| `gd`      | `git diff`                              |
| `ga`      | `git add`                               |
| `gc`      | `git commit`                            |
| `gp`      | `git push`                              |
| `gpl`     | `git pull`                              |
| `gl`      | `git log --oneline --graph --decorate`  |
| `gb`      | `git branch`                            |
| `ll`/`la` | `eza -la --icons` (fallback: `ls -la`)  |
| `lt`      | `eza --tree --icons`                    |
| `ubuntu`  | `ssh eoin@nvidiaubuntubox`              |
| `kb-sync` | `~/.local/bin/sync-knowledge-base.sh`   |
| `kb-build`| `~/.local/bin/rebuild-knowledge-base.sh`|
| `notes`   | cd to iCloud Notes folder *(macOS only)*|
