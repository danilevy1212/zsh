### MY ALIASES
# ranger alias
alias rr=ranger

# kill emacsclient kill server alias
alias ek="emacsclient -e '(kill-emacs)'"

# create a terminal emacs
alias emt="emacs -nw"

# vs-code FIXME This make more sense to define as some sort of function instead, and put it in .local/bin
alias vsc="code --extensions-dir $XDG_CONFIG_HOME/Code\ -\ OSS/extensions"

# nvim
if [ `command -v nvim` ]; then
    alias vim="nvim"
    alias gvim="nvim-qt"
fi

[ -f "$XDG_CONFIG_HOME/zsh/secret_aliases.zsh" ] &&
  source "$XDG_CONFIG_HOME/zsh/secret_aliases.zsh"
