if test (uname -s) = Darwin
    # Homebrew environment (PATH, MANPATH, HOMEBREW_* vars)
    eval (/opt/homebrew/bin/brew shellenv)

    # VS Code CLI
    fish_add_path /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

    # juliaup (Julia version manager)
    fish_add_path $HOME/.juliaup/bin

    if status is-interactive
        # Notes (iCloud)
        abbr -a notes 'cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/My\ Notes'
    end
end
