xsetroot -cursor_name pointer
xterm &
if [ "$1" = "xfce" ]; then
    exec xfce4-session
else
    exec xmonad
fi
