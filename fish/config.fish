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

    # SSH
    abbr -a ubuntu 'ssh eoin@nvidiaubuntubox'

    # Knowledge base
    abbr -a kb-sync  '~/.local/bin/sync-knowledge-base.sh'
    abbr -a kb-build '~/.local/bin/rebuild-knowledge-base.sh'

    # Notes (iCloud — macOS only)
    if test "$os" = "Darwin"
        abbr -a notes 'cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/My\ Notes'
    end
end
