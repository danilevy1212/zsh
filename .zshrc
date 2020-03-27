### GENERAL
# Enable colors
autoload -U colors && colors

# Full 256-color support
export TERM="xterm-256color"

# Do menu-driven completion.
zstyle ':completion:*' menu select
zmodload zsh/complist

# Completions are aware of when trying to gain privileges
zstyle ':completion::complete:*' gain-privileges 1

# Include hidden files.
_comp_options+=(globdots)

# Zsh to use the same colors as ls
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Access to zsh completion functions
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# Access to bash completion functions
autoload -Uz bashcompinit && bashcompinit

# Setup history and history file
export HISTFILE="$XDG_DATA_HOME/history"
export HISTSIZE=100000
export SAVEHIST=100000

# Append history to history file
setopt appendhistory 

# Perform cd to a directory automatically
setopt autocd

# Backward incremental search
bindkey '^R' history-incremental-search-backward

# Beep on error
setopt beep

# Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns
setopt extendedglob

# Print error if there is no match for argument
setopt nomatch

# Report status of background jobs immediately
setopt notify

# Parameter expansion, command substitution and arithmetic expansion are performed in prompts.
setopt PROMPT_SUBST  

# autocompletion of command line switches for aliases
setopt COMPLETE_ALIASES

# git info
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:git:*' formats '%b%c%u'

# colored man pages
function colored() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		PAGER="${commands[less]:-$PAGER}" \
		_NROFF_U=1 \
		PATH="$HOME/bin:$PATH" \
			"$@"
}

function man() {
	colored man "$@"
}

### vi-mode
# Activate
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^h' backward-delete-char
bindkey -v '^?' backward-delete-char

# Let python change prompt for venvs
export VIRTUAL_ENV_DISABLE_PROMPT=

# Customize prompt
NORMAL_MODE_PROMPT='[N]'
INSERT_MODE_PROMPT='<I>'
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M%{$fg[red]%}]%{$reset_color%} %~ $INSERT_MODE_PROMPT "

function zle-line-init zle-keymap-select {
  case ${KEYMAP} in
    (vicmd)      PS1=${PS1/$INSERT_MODE_PROMPT/$NORMAL_MODE_PROMPT} 
      ;;
    (main|viins) PS1=${PS1/$NORMAL_MODE_PROMPT/$INSERT_MODE_PROMPT}
      ;;
    (*) 
      ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# FIXME Use ranger to switch directories and bind it to ctrl-o
# lfcd () {
#     tmp="$(mktemp)"
#     lf -last-dir-path="$tmp" "$@"
#     if [ -f "$tmp" ]; then
#         dir="$(cat "$tmp")"
#         rm -f "$tmp"
#         [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
#     fi
# }
# bindkey -s '^o' 'lfcd\n'

# ci"
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

# ci{, ci(, di{ etc..
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

# Edit line in vim with ctrl-e:
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

### Plugins (loaded from source)
# SyntaxHighlight FIXME use submodule
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] &&
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestions FIXME use submodule
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# FZF
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

# Load nix-env FIXME use XDG_DATA_HOME or Uninstall
[ -f ~/.nix-profile/etc/profile.d/nix.sh ] && . ~/.nix-profile/etc/profile.d/nix.sh

# EMCSCRIPT
# Adding directories to PATH: FIXME use XDG_CONFIG_HOME
PATH="/home/dlevym/Proyects/WASM_WebAssemby/emsdk/upstream/emscripten:/home/dlevym/Proyects/WASM_WebAssemby/emsdk/node/12.9.1_64bit/bin:$PATH"

# Setting environment variables: FIXME use XDG_CONFIG_HOME
EMSDK=/home/dlevym/Proyects/WASM_WebAssemby/emsdk
EMSDK_NODE=/home/dlevym/Proyects/WASM_WebAssemby/emsdk/node/12.9.1_64bit/bin/node

# NVM
export NVM_DIR="$XDG_CONFIG_HOME/nvm"

# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Load aliases
source "$XDG_CONFIG_HOME/zsh/aliases.zsh"

# Load plugins 
source "$XDG_CONFIG_HOME/zsh/plugins/index.zsh"
