# make vim default editor
if [ -n "$(command -v nvim)" ]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# default browser
export BROWSER='firefox'

# default terminal info
export TERM=xterm-256color

# default file-browser
export FILEMANAGER="spacefm"

# NPM and NODE XDG compliance
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc

export LD_LIBRARY_PATH=/usr/local/lib

# Locale in english
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_COLLATE=C
export LC_CTYPE=en_US.UTF-8

# Make local executables visible
export PATH="$HOME/.local/bin:$PATH"

# IBUS
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# Rust
export CARGO_HOME="$XDG_DATA_HOME"/cargo
