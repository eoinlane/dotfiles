# Detect OS
set -l os (uname -s)

# macOS-specific setup
if test "$os" = "Darwin"
    # Homebrew environment (PATH, MANPATH, HOMEBREW_* vars)
    eval (/opt/homebrew/bin/brew shellenv)

    # VS Code CLI
    fish_add_path /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
end

if status is-interactive
    # Starship prompt
    starship init fish | source

    # Zoxide (smart cd)
    zoxide init fish | source

    # --- Abbreviations (expand as you type) ---

    # Git
    abbr -a g    git
    abbr -a gs   git status
    abbr -a gd   git diff
    abbr -a ga   git add
    abbr -a gc   git commit
    abbr -a gp   git push
    abbr -a gpl  git pull
    abbr -a gl   'git log --oneline --graph --decorate'
    abbr -a gb   git branch

    # Filesystem (eza if available, fallback to ls)
    if command -v eza &>/dev/null
        abbr -a ll  'eza -la --icons'
        abbr -a la  'eza -la --icons'
        abbr -a lt  'eza --tree --icons'
    else
        abbr -a ll  'ls -la'
        abbr -a la  'ls -la'
    end

    # Navigation
    abbr -a cd  z

    # SSH
    abbr -a ubuntu 'ssh eoin@nvidiaubuntubox'

    # Knowledge base
    abbr -a kb-sync  '~/.local/bin/sync-knowledge-base.sh'
    abbr -a kb-build '~/.local/bin/rebuild-knowledge-base.sh'

    # Notes (iCloud — macOS only)
    if test "$os" = "Darwin"
        abbr -a notes 'cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/My\ Notes'
    end

    # --- Tool aliases/abbreviations ---

    # bat instead of cat
    if command -v bat &>/dev/null
        abbr -a cat bat
    end

    # fd-find (on FreeBSD the binary is 'fd')
    if command -v fd &>/dev/null
        abbr -a find fd
    else if command -v fd-find &>/dev/null
        alias fd fd-find
        abbr -a find fd-find
    end

    # --- fzf configuration ---
    set -gx FZF_DEFAULT_OPTS '--color=dark --height=40% --layout=reverse --border'

    # Use fd for fzf file search if available
    if command -v fd &>/dev/null
        set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
        set -gx FZF_CTRL_T_COMMAND 'fd --type f --hidden --follow --exclude .git'
    end

    # Source fzf key bindings if available (FreeBSD locations)
    if test -f /usr/local/share/fzf/shell/key-bindings.fish
        source /usr/local/share/fzf/shell/key-bindings.fish
    else if test -f /usr/local/share/fzf/key-bindings.fish
        source /usr/local/share/fzf/key-bindings.fish
    else if test -f /usr/local/share/examples/fzf/shell/key-bindings.fish
        source /usr/local/share/examples/fzf/shell/key-bindings.fish
    end

    # Manual fzf key bindings as fallback
    if not functions -q fzf_key_bindings
        # Ctrl+R: fzf history search
        function __fzf_history
            history | fzf --no-sort --query (commandline) | read -l result
            and commandline -- $result
            commandline -f repaint
        end
        bind \cr __fzf_history

        # Ctrl+T: fzf file search
        function __fzf_find_file
            set -l cmd $FZF_CTRL_T_COMMAND
            if test -z "$cmd"
                set cmd "find . -type f 2>/dev/null"
            end
            eval $cmd | fzf --multi | while read -l result
                commandline -it -- (string escape -- $result)" "
            end
            commandline -f repaint
        end
        bind \ct __fzf_find_file
    else
        fzf_key_bindings
    end
end
