#!/bin/zsh

whitegroups="base base-devel multilib-devel xfce4 xfce4-goodies xorg-input-drivers xorg-video-drivers xorg"
blackgroups="gnome gstreamer0.10-plugins ladspa-plugins gnome-extra"

rm -f packages.list ignore.list
# figure out which groups to install
yaourt -Qga --date > groups.list
cat groups.list | while read group; do
    if [ -z "$(echo "$blackgroups" | grep -o -m 1 "$group")" ]; then
        if [ -n "$(echo "$whitegroups" | grep -o -m 1 "$group")" ]; then
            addgroup="y"
        else
            read -q "addgroup?Install group $group [y/N]: "
        fi
        if [ "$addgroup" = "y" ]; then
            yaourt -Sg $group | grep -o '^[^ ]* ' > $group.list
            echo $group >> packages.list
            grep -o '[^/]*$' $group.list >> ignore.list
            rm -f $group.list
        fi
    fi
done

yaourt -Qea --date | grep -o '^[^ ]* ' | grep -v -F -f ignore.list | grep -o '[^/]* $' >> packages.list

rm -f ignore.list groups.list
