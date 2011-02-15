#!/bin/zsh
here=`dirname $0`

pacman -Syua --noconfirm
pacman -S --needed --noconfirm yaourt
installfile "$here/yaourtrc" "/etc/yaourtrc" 

#TODO: generate packages.list from current install
yaourt -S --noconfirm --needed --aur `cat $here/packages.list`


