# Start XOrg if I'm in tty1 with XMONAD
if [[ "$(tty)" = "/dev/tty1" ]] && [ -n "$(command -v xmonad)" ]; then
  pgrep xmonad || startx
fi
