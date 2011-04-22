#!/bin/zsh
Install group base-devel [y/N]: yInstall group base [y/N]: yInstall group multilib-devel [y/N]: 
Install group gnome-extra [y/N]: 
Install group xfce4 [y/N]: yInstall group gnome [y/N]: nInstall group gstreamer0.10-plugins [y/N]: yInstall group ladspa-plugins [y/N]: nInstall group xfce4-goodies [y/N]: yInstall group xorg-drivers [y/N]: yInstall group xorg [y/N]: yInstall group xorg-apps [y/N]: yInstall group xorg-fonts [y/N]: y
whitegroups="base-devel base xfce4 gstreamer0.10-plugins xorg xorg-drivers xorg-apps xorg-fonts"
blackgroups="multilib-devel gnome-extra gnome ladspa-plugins"

rm -f packages.list
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
