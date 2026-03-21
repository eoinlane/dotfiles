#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

echo "==> Detected OS: $OS"
echo "==> Dotfiles dir: $DOTFILES_DIR"

# ---------------------------------------------------------------------------
# Install fish
# ---------------------------------------------------------------------------
install_fish() {
    if command -v fish &>/dev/null; then
        echo "==> fish already installed: $(command -v fish)"
        return
    fi
    echo "==> Installing fish..."
    case "$OS" in
        Darwin)
            brew install fish
            ;;
        Linux)
            if command -v apt &>/dev/null; then
                sudo apt update && sudo apt install -y fish
            else
                echo "ERROR: Unsupported Linux distro — install fish manually." >&2
                exit 1
            fi
            ;;
        FreeBSD)
            sudo pkg install -y fish
            ;;
        *)
            echo "ERROR: Unsupported OS: $OS" >&2
            exit 1
            ;;
    esac
}

# ---------------------------------------------------------------------------
# Install starship
# ---------------------------------------------------------------------------
install_starship() {
    if command -v starship &>/dev/null; then
        echo "==> starship already installed: $(command -v starship)"
        return
    fi
    echo "==> Installing starship..."
    curl -sS https://starship.rs/install.sh | sh
}

# ---------------------------------------------------------------------------
# Install eza
# ---------------------------------------------------------------------------
install_eza() {
    if command -v eza &>/dev/null; then
        echo "==> eza already installed: $(command -v eza)"
        return
    fi
    echo "==> Installing eza..."
    case "$OS" in
        Darwin)
            brew install eza
            ;;
        Linux)
            if command -v apt &>/dev/null; then
                sudo apt update && sudo apt install -y eza
            else
                echo "WARN: Cannot install eza — install manually via cargo or GitHub releases." >&2
            fi
            ;;
        FreeBSD)
            sudo pkg install -y eza
            ;;
    esac
}

# ---------------------------------------------------------------------------
# Symlink config.fish
# ---------------------------------------------------------------------------
link_config() {
    mkdir -p ~/.config/fish
    local target="$DOTFILES_DIR/fish/config.fish"
    local link="$HOME/.config/fish/config.fish"

    if [ -f "$link" ] && [ ! -L "$link" ]; then
        echo "==> Backing up existing config.fish to config.fish.bak"
        mv "$link" "${link}.bak"
    fi

    ln -sf "$target" "$link"
    echo "==> Linked $link -> $target"
}

# ---------------------------------------------------------------------------
# Set fish as default shell
# ---------------------------------------------------------------------------
set_default_shell() {
    local fish_path
    fish_path="$(command -v fish)"

    if ! grep -qF "$fish_path" /etc/shells; then
        echo "==> Adding $fish_path to /etc/shells"
        echo "$fish_path" | sudo tee -a /etc/shells
    fi

    if [ "$SHELL" = "$fish_path" ]; then
        echo "==> fish is already the default shell"
    else
        chsh -s "$fish_path"
        echo "==> Default shell set to fish (re-login to take effect)"
    fi
}

# ---------------------------------------------------------------------------
# Run
# ---------------------------------------------------------------------------
install_fish
install_starship
install_eza
link_config
set_default_shell

echo ""
echo "==> Done! Start a new shell or run: exec fish"
