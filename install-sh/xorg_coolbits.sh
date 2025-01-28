#! /usr/bin/bash --posix
# create xorg.conf

# xorg.conf with Coolbits set to 12
printf "${GREEN}Create xorg.conf with Coolbits set to 12... \n${NORMAL}"

cat <<EOT >> ~/Public/xorg.conf
Section "Device" 
Identifier "NVIDIA Card" 
Driver "nvidia" 
Option "Coolbits" "12" 
EndSection 

EOT

# set permission to allow copying 
sudo chmod a+r ~/Public/xorg.conf
sudo -E mv ~/Public/xorg.conf /etc/X11/xorg.conf

printf "done... \n"
