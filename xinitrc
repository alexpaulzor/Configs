#!/bin/sh
xsetroot -cursor_name left_ptr
setterm -blank 0 -powersave off -powerdown 0
xset s off
xset -dpms
x11vnc -display :0 &
dropboxd &
pidgin &
xscreensaver &
if [ -d "$HOME/.$(hostname)" -a -x "$HOME/.$(hostname)/xinitrc" ]; then
    . "$HOME/.$(hostname)/xinitrc"
fi
if [ "$1" = "xmonad" ]; then
    exec xmonad
else
    exec xfce4-session
fi
