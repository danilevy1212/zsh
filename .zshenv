# make vim default editor
if [ -n "$(command -v nvim)" ]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# default browser
export BROWSER='firefox'

# default terminal info
if [ -z $PREFIX ]; then
  # export TERM=xterm-termite

  # default terminal
  export TERMINAL=termite
else
  export TERM=xterm-256color
fi

# default file-browser
export FILEMANAGER="ranger"

# Locale in english
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_COLLATE=C
export LC_CTYPE=en_US.UTF-8

# NVM
export NVM_DIR="$XDG_CONFIG_HOME/nvm"

# NPM and NODE XDG compliance
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
