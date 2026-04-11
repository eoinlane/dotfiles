# ==============================
# Eoin's FreeBSD dev config.fish
# ==============================

# ------------
# Environment
# ------------
# Terminal / locale / editor
set -x TERM xterm-256color
set -x LANG C.UTF-8
set -x LC_ALL C.UTF-8
set -x EDITOR vim
set -x VISUAL vim
set -x PAGER less
set -x JULIA_DEPOT_PATH $HOME/julia/packages

# PATH (prepend useful dirs ahead of system PATH)
set -x PATH /usr/local/bin /usr/local/sbin $HOME/.local/bin $HOME/bin $PATH

# Silence the "for instructions on how to use fish" greeting
set -U fish_greeting ""

# --------------------
# Abbreviations (abbr)
# --------------------
abbr -a weather curl wttr.in
abbr -a moon    curl wttr.in/moon
abbr -a ff      fastfetch --config examples/8.jsonc

# -----------------------------
# Prompt (simple but informative)
# -----------------------------
# Shows: [✘ status] user@host pwd (git_branch) >
#

# Open ~/.config/fish/config.fish and add:
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

function fish_prompt
    # Username + host (cyan)
    set_color cyan
    printf "%s@%s " (whoami) (hostname -s)

    # Current working directory (yellow)
    set_color yellow
    printf "%s " (prompt_pwd)

    # Git branch (magenta)
    set -l branch (command git symbolic-ref --short HEAD 2>/dev/null)
    if test -n "$branch"
        set_color magenta
        printf "(%s) " $branch
    end

    # Prompt symbol (green)
    set_color green
    printf "> "

    set_color normal
end

# --------------------------
# Raspberry Pi / mounts
# --------------------------


# Start Pluto in notebooks project
function pluto
    set -l script ~/julia/projects/notebooks/start_pluto.jl

    if not test -x $script
        echo "Making $script executable..."
        chmod +x $script
    end

    echo "Starting Pluto via $script ..."
    $script $argv
end
set -g RASP_MOUNT $HOME/raspberry
set -g RASP_HOST eoin@raspberrypi
set -g RASP_PATH /media/eoin/MyExternalDrive

function mrasp
    if mount | grep -q $RASP_MOUNT
        echo "Already mounted at $RASP_MOUNT"
        return 0
    end
    echo "Mounting Raspberry Pi share..."
    if sshfs $RASP_HOST:$RASP_PATH $RASP_MOUNT -o idmap=user,reconnect,ServerAliveInterval=15
        echo "Mounted at $RASP_MOUNT"
    else
        echo "Mount failed." >&2
        return 1
    end
end

function umrasp
    if not mount | grep -q $RASP_MOUNT
        echo "Not currently mounted."
        return 0
    end
    echo "Unmounting $RASP_MOUNT..."
    if umount $RASP_MOUNT
        echo "Unmounted."
    else
        echo "Unmount failed (files open?)." >&2
        return 1
    end
end

function rasp
    if not mount | grep -q $RASP_MOUNT
        echo "Share not mounted. Run mrasp first."
        return 1
    end
    cd $RASP_MOUNT
end

# --------------------------
# ls / navigation helpers (eza)
# --------------------------
function ll
    eza -lah --icons --git $argv
end

function la
    eza -a --icons $argv
end

function l
    eza --icons $argv
end

function lt
    eza --tree --icons --level=2 $argv
end

# Clear screen
function c
    clear
end

# Create a directory and cd into it
function mkcd
    if test -z "$argv[1]"
        echo "Usage: mkcd <dirname>"
        return 1
    end
    mkdir -p $argv[1]
    cd $argv[1]
end

# Jump to main projects folder (adjust if needed)
function cdp
    cd ~/Projects
end

# --------------------------
# Git helpers
# --------------------------
function gs
    git status $argv
end

function gl
    git log --oneline --graph --decorate $argv
end

function ga
    git add $argv
end

function gc
    git commit $argv
end

function gcm
    if test -z "$argv"
        echo "Usage: gcm <commit message>"
        return 1
    end
    git commit -m "$argv"
end

function gco
    git checkout $argv
end

function gp
    git push $argv
end

# cd to the root of the current git repo
function gitroot
    set -l root (git rev-parse --show-toplevel ^/dev/null 2>/dev/null)
    if test -z "$root"
        echo "Not in a git repository."
        return 1
    end
    cd $root
end

# --------------------------
# FreeBSD / pkg helpers
# --------------------------
function pkgup
    sudo pkg update && sudo pkg upgrade -y
end

function pkgs
    pkg search $argv
end

# --------------------------
# Julia / Pluto helpers
# --------------------------
# Start Julia REPL with a specific project
function jproj
    set -l proj $argv[1]
    if test -z "$proj"
        echo "Usage: jproj <project-dir>"
        echo "Example: jproj ~/julia/myproj"
        return 1
    end
    if not test -d $proj
        echo "Directory not found: $proj"
        return 1
    end
    cd $proj
    echo "Starting Julia in project: $proj"
    julia --project=.
end


# --------------------------
# Python venv helper
# --------------------------
function venv
    if test -z "$argv[1]"
        echo "Usage: venv <path-to-venv>"
        return 1
    end
    set vpath $argv[1]
    if test -f "$vpath/bin/activate.fish"
        source "$vpath/bin/activate.fish"
    else if test -f "$vpath/bin/activate"
        source "$vpath/bin/activate"
    else
        echo "No activate script found in $vpath/bin/"
        return 1
    end
end

# --------------------------
# Config helpers
# --------------------------
# Quick edit fish config
function config_fish
    vim ~/.config/fish/config.fish
end

# Reload fish config without reopening terminal
function reload_fish
    source ~/.config/fish/config.fish
    echo "Fish config reloaded."
end

# --------------------------
# Atuin (shell history)
# --------------------------
atuin init fish | source

# --------------------------
# zoxide (smart cd)
# --------------------------
zoxide init fish | source

# --------------------------
# fzf
# --------------------------
fzf --fish | source
