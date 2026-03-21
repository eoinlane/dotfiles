# dotfiles

Personal shell configuration for macOS, Ubuntu, and FreeBSD.

## Contents

- **`fish/config.fish`** — Fish shell config with Starship prompt, git abbreviations, and platform-specific setup
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
4. Set fish as your default shell

## Platform support

| OS      | Package manager |
|---------|----------------|
| macOS   | Homebrew        |
| Ubuntu  | apt             |
| FreeBSD | pkg             |

## Abbreviations

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
