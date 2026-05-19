# Platform-independent abbreviations, functions, and tool init.
# Sourced after 10-*.fish so PATH is populated for tool detection.

# --- Abbreviations (interactive only) ---
if status is-interactive
    # Misc
    abbr -a weather curl wttr.in
    abbr -a moon    curl wttr.in/moon
    abbr -a ff      'fastfetch --config examples/8.jsonc'

    # Git
    abbr -a g    git
    abbr -a gs   git status
    abbr -a gd   git diff
    abbr -a ga   git add
    abbr -a gc   git commit
    abbr -a gcm  'git commit -m'
    abbr -a gco  git checkout
    abbr -a gp   git push
    abbr -a gpl  git pull
    abbr -a gl   'git log --oneline --graph --decorate'
    abbr -a gb   git branch

    # Filesystem
    if command -v eza &>/dev/null
        abbr -a ll 'eza -lah --icons --git'
        abbr -a la 'eza -a --icons'
        abbr -a l  'eza --icons'
        abbr -a lt 'eza --tree --icons --level=2'
    else
        abbr -a ll 'ls -la'
        abbr -a la 'ls -la'
    end

    # Navigation
    abbr -a cd z

    # tmux session launcher
    abbr -a home '~/dotfiles/tmux/start-home.sh'

    # SSH shortcuts
    abbr -a ubuntu 'ssh eoin@nvidiaubuntubox'

    # Knowledge base
    abbr -a kb-sync  '~/.local/bin/sync-knowledge-base.sh'
    abbr -a kb-build '~/.local/bin/rebuild-knowledge-base.sh'

    # Tool swaps
    if command -v bat &>/dev/null
        abbr -a cat bat
    end

    if command -v fd &>/dev/null
        abbr -a find fd
    else if command -v fd-find &>/dev/null
        alias fd fd-find
        abbr -a find fd-find
    end
end

# --- Functions (always defined; harmless when not called) ---

# yazi with cwd integration
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function c
    clear
end

function mkcd
    if test -z "$argv[1]"
        echo "Usage: mkcd <dirname>"
        return 1
    end
    mkdir -p $argv[1]
    cd $argv[1]
end

function cdp
    cd ~/Projects
end

function gitroot
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$root"
        echo "Not in a git repository."
        return 1
    end
    cd $root
end

function jproj
    set -l proj $argv[1]
    if test -z "$proj"
        echo "Usage: jproj <project-dir>"
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

function config_fish
    vim ~/.config/fish/conf.d/
end

function reload_fish
    for f in ~/.config/fish/conf.d/*.fish
        source $f
    end
    echo "Fish config reloaded."
end

# --- fzf environment ---
set -gx FZF_DEFAULT_OPTS '--color=dark --height=40% --layout=reverse --border'
if command -v fd &>/dev/null
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND 'fd --type f --hidden --follow --exclude .git'
end

# --- Tool init (interactive only) ---
if status is-interactive
    if command -v starship &>/dev/null
        starship init fish | source
    end

    if command -v zoxide &>/dev/null
        zoxide init fish | source
    end

    if command -v atuin &>/dev/null
        atuin init fish | source
    end

    if command -v fzf &>/dev/null
        fzf --fish | source
    end
end
