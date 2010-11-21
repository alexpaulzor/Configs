#!/bin/sh

here=`dirname $0`
cp $here/inittab /etc/inittab
cp $here/mirrorlist /etc/pacman.d/mirrorlist
cp $here/pacman.conf /etc/pacman.conf
cp $here/rc.conf /etc/rc.conf
cp $here/sudoers /etc/sudoers
chown root /etc/sudoers
chgrp root /etc/sudoers
chmod 440 /etc/sudoers
pacman -Syu
pacman -S --needed yaourt
cp $here/yaourtrc /etc/yaourtrc
yaourt -S --noconfirm --needed `cat $here/packages.list`
