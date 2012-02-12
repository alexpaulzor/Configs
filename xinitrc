#!/bin/sh
xsetroot -cursor_name left_ptr
setterm -blank 0 -powersave off -powerdown 0
xset s off
xset -dpms
#x11vnc -display :0 &
#pidgin &
xscreensaver &
xbindkeys
start-pulseaudio-x11
if [ "$1" = "xmonad" ]; then
    export AWT_TOOLKIT=MToolkit
    exec xmonad
else
    exec xfce4-session
fi
