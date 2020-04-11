#! /usr/bin/bash --posix
# Enable user gdm autologin

sudo -E sed -i '/AutomaticLoginEnable=/ c\AutomaticLoginEnable=True' /etc/gdm/custom.conf
sudo -E sed -i '/AutomaticLogin=/ c\AutomaticLogin='$USER /etc/gdm/custom.conf

echo -e "done"

