#! /usr/bin/bash --posix
# create boot-sh.desktop file to boot miner during login...

echo -e "create boot-sh.desktop file to boot miner during login\nPlease input script:    \n\n"
read BOOT_SH

cat <<EOT >> ~/Public/boot-sh.desktop
[Desktop Entry]
Type=Application
Exec="$BOOT_SH" 
Hidden=false
NoDisplay=false
Terminal=true
Name[en_GB]=miner startup
Name=miner startup
Comment[en_GB]=start miner
Comment=start miner
X-GNOME-Autostart-Delay=60
X-GNOME-Autostart-enabled=true

EOT
# set permission to allow copying
sudo -E cp ~/Public/boot-sh.desktop /etc/xdg/autostart/miner.desktop
sudo chmod u+r /etc/xdg/autostart/miner.desktop
rm ~/Public/boot-sh.desktop
echo -e "done"
