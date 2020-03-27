# Current folder
export ZPLUGINS_FOLDER="$(dirname "$(readlink -f "$0")")"

## Z for autocompletion
# Put cache file 
export _Z_DATA="$XDG_CACHE_HOME/z"
source "$ZPLUGINS_FOLDER/zsh-z/zsh-z.plugin.zsh"
