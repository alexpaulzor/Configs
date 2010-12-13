xsetroot -cursor_name left_ptr
xterm &
if [ "$1" = "xfce" ]; then
    exec xfce4-session
else
    exec xmonad
fi
