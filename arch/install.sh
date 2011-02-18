#!/bin/zsh

# some prereqs
pacman -S --needed --noconfirm vim git zsh sudo

here=`dirname $0`

# rc.conf
# fix hostname
if [ $(hostname) = "myhost" ]; then
    read "newname?Enter hostname:"
    sed  -e "s/HOSTNAME='myhost'/HOSTNAME='$newname'" < /etc/rc.conf > /tmp/rc.conf
    sudo mv /tmp/rc.conf /etc/rc.conf
fi
# fix daemons
#TODO: 

pacman -Syu --noconfirm
pacman -S --needed --noconfirm yaourt
cp "$here/yaourtrc" "/etc/yaourtrc" 

#TODO: generate packages.list from current install
yaourt -S --noconfirm --needed --aur `cat $here/packages.list`


