#!/bin/zsh
whitegroups="base-devel base xfce4 gstreamer0.10-plugins xorg xorg-apps xorg-fonts xfce4-goodies"
blackgroups="multilib-devel gnome-extra gnome ladspa-plugins xorg-drivers pulseaudio-gnome"

list=$(hostname).list

rm -f $list
# figure out which groups to install
yaourt -Qga --date > groups.list
cat groups.list | while read group; do
    if [ -z "$(echo "$blackgroups" | grep -o -m 1 "$group")" ]; then
        if [ -n "$(echo "$whitegroups" | grep -o -m 1 "$group")" ]; then
            addgroup="y"
        else
            read -q "addgroup?Install group $group [y/N]: "
            echo
        fi
        if [ "$addgroup" = "y" ]; then
            yaourt -Sg $group | grep -o '^[^ ]* ' > $group.list
            echo $group >> $list
            grep -o '[^/]*$' $group.list >> ignore.list
            rm -f $group.list
        fi
    fi
done

yaourt -Qea --date | grep -o '^[^ ]* ' | grep -v -F -f ignore.list | grep -o '[^/]* $' | grep -o '^[^ ]*' >> $list

rm -f ignore.list groups.list
