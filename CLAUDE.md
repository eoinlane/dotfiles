# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Personal dotfiles with a `bootstrap.sh` installer that sets up Fish shell, Neovim, Starship, lf, Alacritty, and supporting tools. Configs live here and are **symlinked** to `~/.config/` locations.

## Bootstrap

```bash
./bootstrap.sh        # Full install: packages + symlinks + set fish as default shell
```

The script auto-detects the OS and branches on: macOS (Homebrew), Ubuntu/Debian (apt), Arch/CachyOS (pacman), FreeBSD (pkg). After running, open Neovim and run `:Lazy sync` to install plugins.

## Symlink Targets

| Source | Destination |
|--------|-------------|
| `fish/conf.d/` | `~/.config/fish/conf.d/` |
| `nvim/` | `~/.config/nvim` |
| `lf/lfrc`, `lf/preview`, `lf/clean` | `~/.config/lf/` |
| `alacritty/alacritty.toml` | `~/.config/alacritty/alacritty.toml` (macOS only) |

## Architecture

### Neovim (`nvim/`)
- Entry point: `nvim/init.lua` — requires `options`, `keymaps`, `misc`, then all plugin modules
- Plugins live in `nvim/lua/plugins/` as individual files, loaded via [lazy.nvim](https://github.com/folke/lazy.nvim)
- LSP servers managed by Mason (auto-installs on first open)
- AI integration via `codecompanion.nvim` using `ANTHROPIC_API_KEY`
- Formatter: `conform.nvim` (stylua, goimports, black, prettier, shfmt)

### Fish (`fish/conf.d/`)
- Fish auto-sources every `*.fish` in `~/.config/fish/conf.d/` (alphabetical order). No top-level `config.fish`.
- `00-env.fish` — platform-independent env vars (EDITOR, PAGER, fish_greeting)
- `10-macos.fish` — guarded with `test (uname -s) = Darwin`: Homebrew shellenv, VS Code CLI, juliaup PATH, `notes` abbr
- `10-freebsd.fish` — guarded: locale/PATH, `mrasp`/`umrasp`/`rasp`, `pkgup`/`pkgs`, `pluto`, fzf bindings
- `10-linux.fish` — guarded placeholder for Linux-specific config
- `50-common.fish` — abbreviations (git, eza, tools), helper functions, fzf env, starship/zoxide/atuin/fzf init
- Sway-only: `01-sway-autostart.fish` (FreeBSD ttyv0 login → `exec sway`)
- Add platform-specific config by editing the matching `10-*.fish` file. Add cross-platform abbrs/functions to `50-common.fish`.

### XFCE (`xfce/`)
- Linux desktop configs: Starship theme, picom, plank, rofi, conky, autostart scripts
- `xfce/starship.toml` is the Linux Starship config (macOS uses the system default)

### lf (`lf/`)
- `lfrc`: main config — sets shell to fish, 1:2:3 pane ratios, trash-based deletion
- `preview`: shell script for file previews (chafa for images, bat/highlight for text)
- `clean`: called by lf to clean up preview artifacts

## Adding a New Tool

1. Create a directory `toolname/` with the config file(s)
2. Add symlink logic to `bootstrap.sh` following the existing pattern (backup existing, `ln -sf`)
3. Add package installation for each supported OS (macOS/Ubuntu/Arch/FreeBSD sections)

## Adding a Neovim Plugin

Add a new file to `nvim/lua/plugins/` returning a lazy.nvim spec table. The file is auto-discovered by lazy.nvim via the `plugins` directory import in `init.lua`.
