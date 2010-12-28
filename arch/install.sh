#!/bin/zsh


here=`dirname $0`

# installfile(srcfile, dstfile)
installfile()
{
    if [ -e $2 ]; then
        changes=`diff $2 $1`
        if [ -z "$changes" ]; then
            echo "$1 and $2 are already the same.  Skipping..."
        else
            echo "$1 and $2 differ."
            echo "$changes"
            read -q "choice?Overwrite? [y/N]:"
            if [ "$choice" = "y" ]; then
                echo "Copying $1 over $2..."
                cp "$1" "$2"
            else
                echo "Skipping $1..."
            fi
        fi
    else
        echo "$2 does not exist.  Installing $1 to $2..."
        cp "$1" "$2"
    fi
}

installfile "$here/inittab" "/etc/inittab" 
installfile "$here/mirrorlist" "/etc/pacman.d/mirrorlist" 
installfile "$here/pacman.conf" "/etc/pacman.conf" 
installfile "$here/rc.conf" "/etc/rc.conf" 

pacman -Syu
pacman -S --needed yaourt
installfile "$here/yaourtrc" "/etc/yaourtrc" 
yaourt -S --noconfirm --needed --aur `cat $here/packages.list`


