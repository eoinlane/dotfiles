# Platform-independent environment variables.
# Locale and PATH are handled in platform files (10-*.fish).

set -x EDITOR vim
set -x VISUAL vim
set -x PAGER less

# Silence the interactive greeting
set -U fish_greeting ""
