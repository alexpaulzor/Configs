#!/bin/zsh

rm -f packages.list ignore.list

# figure out which groups to install
yaourt -Qga --date > groups.list
cat groups.list | while read group; do
    echo
    read -q "addgroup?Install group $group [y/N]: "
    if [ "$addgroup" = "y" ]; then
        yaourt -Sg $group | grep -o '^[^ ]*' > $group.list
        echo $group >> packages.list
        grep -o '[^/]*$' $group.list >> ignore.list
        rm -f $group.list
    fi
done

yaourt -Qea --date | grep -o '^[^ ]*' > explicit.list
grep -v -F -f ignore.list explicit.list | grep -o '[^/]*$' >> packages.list

rm -f ignore.list explicit.list groups.list




