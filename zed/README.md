# Zed

Config for the [Zed](https://zed.dev) editor — Catppuccin Mocha, MesloLGS Nerd
Font, vim mode, and a local-Ollama AI assistant.

## Files

- `settings.json` — main config
- `keymap.json` — user keybindings (`cmd-shift-a` toggles the AI agent panel,
  `cmd-shift-n` starts a new agent thread)

## Install

`bootstrap.sh` handles this, but manually:

```bash
mkdir -p ~/.config/zed
ln -sf ~/dotfiles/zed/keymap.json ~/.config/zed/keymap.json
cp -n ~/dotfiles/zed/settings.json ~/.config/zed/settings.json   # copy, then edit the IP
```

`keymap.json` is **symlinked** (no secrets), but `settings.json` is **copied,
not symlinked** — it contains a host-specific Ollama address you fill in per
machine, so the live file diverges from this template.

## ⚠️ Set your Ollama host

This repo is public, so `settings.json` ships a placeholder:

```jsonc
"api_url": "http://OLLAMA_HOST:11434"
```

After installing, edit `~/.config/zed/settings.json` and replace `OLLAMA_HOST`
with your Ollama server's real host:port. If you don't run Ollama, delete the
`language_models` and `agent` blocks and Zed falls back to its own AI provider.

The Catppuccin theme/icons + Julia/TOML extensions auto-install on first launch
via `auto_install_extensions`.
