#!/bin/zsh
here=`dirname $0`
force=""
while [ -n "$1" ]; do
    if [ "$1" = "-f" ]; then
        force="true"
    fi
    shift
done

# installfile(srcfile, dstfile[, filtercmd])
installfile()
{
    mkdir -p $(dirname "$2")
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
if [ ! -e "/etc/rc.conf" -o "$force" ]; then
    tmpfile=$(mktemp)
    read "hostname?Hostname: "
    sed -e "s/%_HOSTNAME%/$hostname/g" < "$here/rc.conf" > "$tmpfile"
    installfile "$tmpfile" "/etc/rc.conf"
    rm -f "$tmpfile"
fi

if [ ! -e "$HOME/.config/aurvote" -o "$force" ]; then
    read "aurun?AUR username: "
    read -s "aurpw?AUR password: "
    tmpfile=$(mktemp)
    echo "user=$aurun\npass=$aurpw" > "$tmpfile"
    installfile "$tmpfile" "$HOME/.config/aurvote"
    rm -f "$tmpfile"
fi

pacman -Syua --noconfirm
pacman -S --needed --noconfirm yaourt
installfile "$here/yaourtrc" "/etc/yaourtrc" 
#TODO: generate packages.list from current install
yaourt -S --noconfirm --needed --aur `cat $here/packages.list`


