#! /usr/bin/bash --posix

# Upgrade system from Fedora 2X -> 32

sudo dnf -y install dnf-plugin-system-upgrade

sudo dnf -y system-upgrade download --releasever=32

#sudo dnf -y system-upgrade reboot

echo -e "done"
