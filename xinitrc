xsetroot -cursor_name left_ptr
dropboxd &
pidgin &
xscreensaver &
if [ "$1" = "xfce4" ]; then
    exec xfce4-session
else
    exec xmonad
fi
