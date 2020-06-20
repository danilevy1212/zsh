# Current folder
export ZPLUGINS_FOLDER="$(dirname "$(readlink -f "$0")")"

## Z for autocompletion
# Put cache file
export _Z_DATA="$XDG_CACHE_HOME/z"
source "$ZPLUGINS_FOLDER/zsh-z/zsh-z.plugin.zsh"

## Vterm integration
source "$ZPLUGINS_FOLDER/vterm-integration/vterm.zsh"

## Tmux XDG Integrations
alias tmux=tmux -f "$XDG_CONFIG_HOME"/tmux/tmux.conf
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
