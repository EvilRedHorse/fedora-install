#! /bin/sh

# create miner overclock script
echo -e "\ncreate miner overclock script...\n\n"
cat <<EOT >> ~/Public/nvidia_1070_oc.sh
#! /bin/sh
# overclock Zotac 1070 AMP Extreme

nvidia-settings -a [gpu:0]/GPUMemoryTransferRateOffset[3]=1124

nvidia-settings -a [gpu:0]/GPUGraphicsClockOffset[3]=128

EOT
# set permission to allow executing script
chmod u+x ~/Public/nvidia_1070_oc.sh


# create overclock.desktop...
echo -e "create overclock.desktop file to overclock miner during login...\n\n"
cat <<EOT >> ~/Public/overclock.desktop
[Desktop Entry]
Type=Application
Exec= ~/Public/nvidia_1070_oc.sh
Hidden=false
NoDisplay=false
Terminal=true
Name[en_GB]=overclock
Name=overclock
Comment[en_GB]=overclock
Comment=overclock
X-GNOME-Autostart-Delay=60
X-GNOME-Autostart-enabled=true

EOT
# set permission to allow copying
sudo -E cp ~/Public/overclock.desktop /etc/xdg/autostart/overclock.desktop
chmod u+r /etc/xdg/autostart/overclock.desktop
rm ~/Public/overclock.desktop
echo -e "done"

