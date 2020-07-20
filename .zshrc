## XDG (PREFIX only used for termux compatibily)
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_DIRS="$PREFIX/usr/local/share/:$PREFIX/usr/share/"
export XDG_CONFIG_DIRS="$PREFIX/etc/xdg"
export XDG_CACHE_HOME="$HOME/.cache"

### GENERAL
# Enable colors
autoload -U colors && colors

# Do menu-driven completion.
zstyle ':completion:*' menu select
zmodload zsh/complist

# Completions are aware of when trying to gain privileges
zstyle ':completion::complete:*' gain-privileges 1

# Include hidden files.
_comp_options+=(globdots)

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

## Termite dynamic directories
if [[ "$TERM" == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi

# Use ranger to switch directories and bind it to ctrl-o
ranger-cd () {
    tempfile='/tmp/choosedir'
    ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

bindkey -vs "\ez" 'ranger-cd^M'

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

### Plugins (manual)

## VTERM
# The main goal of these additional functions is to enable the shell to send information to vterm via properly escaped sequences.
function vterm_printf(){
    if [ -n "$TMUX" ]; then
        # Tell tmux to pass the escape sequences through
        # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

# Proper clear
if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi

## TMUX XDG Integrations
alias tmux=tmux -f "$XDG_CONFIG_HOME"/tmux/tmux.conf
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"

### Plugins (managed)
## ZINIT
declare -A ZINIT
ZINIT[HOME_DIR]="$XDG_CONFIG_HOME/zinit"

if [[ ! -f $XDG_CONFIG_HOME/zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$XDG_CONFIG_HOME/zinit" && command chmod g-rwX "$XDG_CONFIG_HOME/zinit"
    command git clone https://github.com/zdharma/zinit "$XDG_CONFIG_HOME/zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$XDG_CONFIG_HOME/zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes.
# (this is currently required for annexes)
zinit wait light-mode lucid for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

# Remember my directories dammit!
export _Z_DATA="$XDG_CACHE_HOME/z"

zinit ice wait lucid
zinit light agkozak/zsh-z

# Show me those delicious suggestions!
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Syntax highlighting
zinit ice wait lucid
zinit light zdharma/fast-syntax-highlighting

# NVM
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true

zinit ice wait lucid
zinit light lukechilds/zsh-nvm

# FZF
zinit ice as"program" \
      pick="$ZPFX/bin/(fzf|fzf-tmux)" \
      src="shell/key-bindings.zsh" \
      atclone="mv install install.sh; \
              ./install.sh --all --xdg --no-bash --no-fish --no-zsh; \
              cp shell/completion.zsh _fzf_completion; \
              cp bin/(fzf|fzf-tmux) $ZPFX/bin;"\
      atpull"%atclone"
zinit light junegunn/fzf

[ "$(command -v rg)" ] && \
    export FZF_DEFAULT_COMMAND="rg --files --hidden --smart-case --glob '!.git/*'"

# Tab completion with fzf
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts \
       --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' \
       --preview-window=down:3:wrap

# Provides the LS_COLORS definitions for GNU ls
zinit pack lucid wait for ls_colors

## ALIASES
source "$XDG_CONFIG_HOME/zsh/aliases.zsh"

## Finally, show off! (If I can)
[ -n "$(command -v neofetch)" ] && { print "\n"; neofetch; }
