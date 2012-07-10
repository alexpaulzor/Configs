#!/bin/bash

# some prereqs
sudo pacman -S --needed --noconfirm vim git zsh sudo

here=$(dirname $0)

# add archlinuxfr repo
if [ -z "$(grep "archlinuxfr" /etc/pacman.conf)" ]; then
    echo "Adding archlinuxfr repo"
    sudo cat >> /etc/pacman.conf <<EOF
    [archlinuxfr]
    Server = http://repo.archlinux.fr/x86_64
EOF
fi

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm yaourt

yaourt -S --needed --aur $(cat $here/packages.list | tr "\n" " ")

echo "Now, update sessions in /etc/slim.conf"

