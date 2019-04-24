#! /usr/bin/sh
# create xorg.conf

echo -e "create xorg.conf...\n\n"
cat <<EOT >> ~/Public/xorg.conf
Section "Device" 
Identifier "NVIDIA Card" 
Driver "nvidia" 
Option "Coolbits" "12" 
EndSection 

EOT

# set permission to allow copying 
chmod u+r ~/Public/xorg.conf

sudo -E cp ~/Public/xorg.conf /etc/X11/xorg.conf

rm ~/Public/xorg.conf
sudo dnf -y install nvidia-xconfig
sudo -E nvidia-xconfig -s
echo -e "done"
