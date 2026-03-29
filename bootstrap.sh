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
# Install zoxide
# ---------------------------------------------------------------------------
install_zoxide() {
    if command -v zoxide &>/dev/null; then
        echo "==> zoxide already installed: $(command -v zoxide)"
        return
    fi
    echo "==> Installing zoxide..."
    case "$OS" in
        Darwin)
            brew install zoxide
            ;;
        Linux)
            if command -v apt &>/dev/null; then
                sudo apt update && sudo apt install -y zoxide
            else
                echo "WARN: Cannot install zoxide — install manually via cargo or https://github.com/ajeetdsouza/zoxide" >&2
            fi
            ;;
        FreeBSD)
            sudo pkg install -y zoxide
            ;;
    esac
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
# Install neovim
# ---------------------------------------------------------------------------
install_nvim() {
    if command -v nvim &>/dev/null; then
        echo "==> nvim already installed: $(command -v nvim)"
        return
    fi
    echo "==> Installing nvim..."
    case "$OS" in
        Darwin)
            brew install neovim
            ;;
        Linux)
            if command -v snap &>/dev/null; then
                sudo snap install nvim --classic
            elif command -v apt &>/dev/null; then
                # apt version is too old; install via snap or AppImage
                echo "WARN: apt neovim is outdated. Installing via snap..."
                sudo apt install -y snapd && sudo snap install nvim --classic
            else
                echo "WARN: Cannot install nvim — install manually from https://github.com/neovim/neovim/releases" >&2
            fi
            ;;
        FreeBSD)
            sudo pkg install -y neovim gmake
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
# Symlink nvim config
# ---------------------------------------------------------------------------
link_nvim() {
    mkdir -p ~/.config
    local target="$DOTFILES_DIR/nvim"
    local link="$HOME/.config/nvim"

    if [ -d "$link" ] && [ ! -L "$link" ]; then
        echo "==> Backing up existing nvim config to nvim.bak"
        mv "$link" "${link}.bak"
    fi

    ln -sfn "$target" "$link"
    echo "==> Linked $link -> $target"
}

# ---------------------------------------------------------------------------
# Symlink XFCE desktop configs (FreeBSD only)
# ---------------------------------------------------------------------------
link_xfce() {
    if [ "$OS" != "FreeBSD" ]; then
        echo "==> Skipping XFCE config (not FreeBSD)"
        return
    fi

    echo "==> Linking XFCE desktop configs..."

    # Directories to symlink: dotfiles path -> ~/.config path
    local -A dirs=(
        ["xfce4"]="xfce4"
        ["autostart"]="autostart"
        ["picom"]="picom"
        ["rofi"]="rofi"
        ["plank"]="plank"
        ["fontconfig"]="fontconfig"
        ["qt5ct"]="qt5ct"
        ["conky"]="conky"
        ["gtk-3.0"]="gtk-3.0"
        ["Thunar"]="Thunar"
        ["pulse"]="pulse"
        ["lf"]="lf"
    )

    for src in "${!dirs[@]}"; do
        local target="$DOTFILES_DIR/xfce/$src"
        local link="$HOME/.config/${dirs[$src]}"

        if [ -d "$link" ] && [ ! -L "$link" ]; then
            echo "    Backing up $link -> ${link}.bak"
            mv "$link" "${link}.bak"
        fi

        ln -sfn "$target" "$link"
        echo "    Linked $link -> $target"
    done

    # Starship config (single file)
    ln -sf "$DOTFILES_DIR/xfce/starship.toml" "$HOME/.config/starship.toml"
    echo "    Linked ~/.config/starship.toml"

    # Custom scripts
    mkdir -p "$HOME/.local/bin"
    for script in "$DOTFILES_DIR"/xfce/scripts/*; do
        local name
        name="$(basename "$script")"
        ln -sf "$script" "$HOME/.local/bin/$name"
        echo "    Linked ~/.local/bin/$name"
    done
}

# ---------------------------------------------------------------------------
# Run
# ---------------------------------------------------------------------------
install_fish
install_starship
install_zoxide
install_eza
install_nvim
link_config
link_nvim
link_xfce
set_default_shell

echo ""
echo "==> Done! Start a new shell or run: exec fish"
echo "==> Open nvim and run :Lazy sync to install plugins"
