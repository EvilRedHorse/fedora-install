#! /usr/bin/sh

# Upgrade system from Fedora 2X -> 28

sudo dnf -y install dnf-plugin-system-upgrade

sudo dnf -y system-upgrade download --releasever=28

#sudo dnf -y system-upgrade reboot

echo -e "done"
