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

# XDG (PREFIX only used for termux compatibily)
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_DIRS="$PREFIX/usr/local/share/:$PREFIX/usr/share/"
export XDG_CONFIG_DIRS="$PREFIX/etc/xdg"
export XDG_CACHE_HOME="$HOME/.cache"

# Start XOrg if I'm in tty1 with XMONAD
if [[ "$(tty)" = "/dev/tty1" ]] && [ -n "$(command -v xmonad)" ]; then
  pgrep xmonad || startx
fi
