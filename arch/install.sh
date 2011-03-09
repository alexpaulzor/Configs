#!/bin/zsh

# some prereqs
sudo pacman -S --needed --noconfirm vim git zsh sudo

here=$(dirname $0)

# add archlinuxfr repo
if [ -z "$(grep "archlinuxfr" /etc/pacman.conf)" ]; then
    echo "Adding archlinuxfr repo"
    sudo echo "[archlinuxfr]\nServer = http://repo.archlinux.fr/x86_64" >> /etc/pacman.conf
fi

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm yaourt
sudo cp "$here/yaourtrc" "/etc/yaourtrc" 

yaourt -S --needed --aur $(cat $here/packages.list | tr "\n" " ")

# rc.conf
# fix hostname
if [ $(hostname) = "myhost" ]; then
    read "newname?Enter hostname:"
    sed  -e "s/HOSTNAME='myhost'/HOSTNAME='$newname'/" < /etc/rc.conf > /tmp/rc.conf
    sudo mv /tmp/rc.conf /etc/rc.conf
fi

# fix daemons
daemonline=$(grep '^DAEMONS=.*$' /etc/rc.conf | grep -o '[(].*[)]' | tr -d '()')

for svc in syslog-ng network crond sshd hal dbus; do
    if [ -z "$(echo $daemonline | grep $svc)" ]; then
        echo "Adding daemon $svc"
        daemonline="$daemonline $svc"
    fi
done
sed  -e "s/DAEMONS=.*\$/DAEMONS=($daemonline)/" < /etc/rc.conf > /tmp/rc.conf
sudo mv /tmp/rc.conf /etc/rc.conf

echo "Configuring inittab"
cat /etc/inittab | sed -e 's/^id:3:initdefault:$/#id:3:initdefault:/' | sed -e 's/^#id:5:initdefault:$/id:5:initdefault:/' | sed -e 's_^x:5:respawn:/usr/bin/xdm_#x:5:respawn:/usr/bin/xdm_' | sed -e 's_^#x:5:respawn:/usr/bin/slim_x:5:respawn:/usr/bin/slim_' > /tmp/inittab
sudo mv /tmp/inittab /etc/inittab

if [ -z "$(grep '^sshd: ALL$' /etc/hosts.allow)" ]; then
    echo "Enabling sshd in hosts.allow"
    cp /etc/hosts.allow /tmp/hosts.allow
    echo "sshd: ALL" >> /tmp/hosts.allow
    sudo mv /tmp/hosts.allow /etc/hosts.allow
fi

echo "Configuring slim.conf"
sed -e 's/^sessions.*$/sessions    xmonad,xfce4/' < /etc/slim.conf > /tmp/slim.conf
sudo mv /tmp/slim.conf /etc/slim.conf
