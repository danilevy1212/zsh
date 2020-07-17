### MY ALIASES
# ranger alias
alias rr=ranger

# kill emacsclient kill server alias
alias ek="emacsclient -e '(kill-emacs)'"

# create a terminal emacs
alias emt="emacs -nw"

# nvim
if [ "$(command -v nvim)" ]; then
    alias vim="nvim"
    alias gvim="nvim-qt"
fi

# colorized ls
alias ls='ls --color=auto'

[ -f "$XDG_CONFIG_HOME/zsh/secret_aliases.zsh" ] &&
  source "$XDG_CONFIG_HOME/zsh/secret_aliases.zsh"
