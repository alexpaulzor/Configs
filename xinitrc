#!/bin/sh
xsetroot -cursor_name left_ptr
setterm -blank 0 -powersave off -powerdown 0
xset s off
xset -dpms
#x11vnc -display :0 &
pidgin &
xscreensaver &
if [ "$1" = "xfce4" ]; then
    exec xfce4-session
else
    exec xmonad
fi
