#!/bin/sh
xsetroot -cursor_name left_ptr
setterm -blank 0 -powersave off -powerdown 0
xset s off
xset -dpms
#x11vnc -display :0 &
#pidgin &
(while true; do xscreensaver; done) &
xbindkeys
xmodmap .xmodmaprc
start-pulseaudio-x11
if [ "$1" = "xfce4" ]; then
    exec xfce4-session
else
    export AWT_TOOLKIT=MToolkit
    exec xmonad
fi
