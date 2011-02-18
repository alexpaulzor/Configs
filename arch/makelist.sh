#!/bin/zsh

rm -f packages.list ignore.list
# figure out which groups to install
yaourt -Qga --date > groups.list
cat groups.list | while read group; do
    echo
    read -q "addgroup?Install group $group [y/N]: "
    if [ "$addgroup" = "y" ]; then
        yaourt -Sg $group | grep -o '^[^ ]* ' > $group.list
        echo $group >> packages.list
        grep -o '[^/]*$' $group.list >> ignore.list
        rm -f $group.list
    fi
done

yaourt -Qea --date | grep -o '^local/[^ ]* ' > aurpkgs.list
yaourt -Qea --date | grep -o '^[^ ]* ' | grep -v '^local/' | grep -v -F -f ignore.list > explicit.list
grep -o '[^/]* $' explicit.list >> packages.list

rm -f ignore.list groups.list




