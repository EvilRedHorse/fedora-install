#! /usr/bin/bash --posix

# script to setup a fedora + nvidia based miner

# create folder ZEC in user home
echo -e "\ncreate ZEC folder in $USER home folder...\n\n"
mkdir ~/ZEC

echo -e "Downloading miner and extracting..."
wget -qO- https://github.com/nanopool/ewbf-miner/releases/download/v0.3.4b/Zec.miner.0.3.4b.Linux.Bin.tar.gz | tar xvz -C ~/ZEC

# create miner startup script
echo -e "create miner script...\n\n"
cat <<EOT >> ~/ZEC/start_miner.sh
#! /bin/sh

# execute overclock script
~/ZEC/nvidia_1070_oc.sh

# start miner on Slushpool
~/ZEC/miner --eexit 1 --solver 0  --server us.zec.slushpool.com --port 4444 --user RASPIE45.Worker_2 --pass anything --fee 000

EOT
# set permission to allow executing script
chmod u+x ~/ZEC/start_miner.sh

# create miner overclock script
echo -e "\ncreate miner overclock script...\n\n"
cat <<EOT >> ~/ZEC/nvidia_1070_oc.sh
#! /bin/sh
# overclock Zotac 1070 AMP Extreme

nvidia-settings -a [gpu:0]/GPUMemoryTransferRateOffset[3]=1124

nvidia-settings -a [gpu:0]/GPUGraphicsClockOffset[3]=128

EOT
# set permission to allow executing script
chmod u+x ~/ZEC/nvidia_1070_oc.sh

# create xorg.conf
echo -e "create xorg.conf...\n\n"
cat <<EOT >> ~/ZEC/xorg.conf
Section "Device" 
Identifier "NVIDIA Card" 
Driver "nvidia" 
Option "Coolbits" "12" 
EndSection 

EOT
# set permission to allow copying 
chmod u+r ~/ZEC/xorg.conf


# create miner.desktop
echo -e "create miner.desktop...\n\n"
cat <<EOT >> ~/ZEC/miner.desktop
[Desktop Entry]
Type=Application
Exec= ~/ZEC/start_miner.sh
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
chmod u+r ~/ZEC/miner.desktop

# create nvidia config script
echo -e "create nvidia config script...\n\n"
cat <<EOT >> ~/ZEC/nvidia_config.sh
#! /bin/sh

dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf -y install akmod-nvidia

dnf -y install xorg-x11-drv-nvidia akmod-nvidia "kernel-devel-uname-r == $(uname -r)"

dnf -y install xorg-x11-drv-nvidia-cuda

dnf -y install xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-libs

dnf -y install vdpauinfo libva-vdpau-driver libva-utils

dnf -y groupinstall "C Development Tools and Libraries"

dnf -y install libcurl-devel openssl-devel

dnf -y install libGLU-devel libXi-devel libXmu-devel

#dnf -y install pitivi

echo -e "\nupdating startup files...\n\n"
sudo -E cp ~/ZEC/xorg.conf /etc/X11/xorg.conf
sudo -E cp ~/ZEC/miner.desktop /etc/xdg/autostart/miner.desktop
sed -i '/AutomaticLoginEnable=/ c\AutomaticLoginEnable=True' /etc/gdm/custom.conf
sed -i '/AutomaticLogin=/ c\AutomaticLogin='$USER /etc/gdm/custom.conf


echo -e "\ngoing down in 1 minute...\n\n"
shutdown --reboot 1 "going down in 1 minute..."

EOT
# set permission to allow executing script
chmod u+x ~/ZEC/nvidia_config.sh

# create fedora upgrade script
echo -e "create fedora upgrade script...\n\n"
cat <<EOT >> ~/ZEC/fedora_upgrade.sh
#! /usr/bin/sh

# Upgrade system from Fedora 2X -> 27

dnf -y install dnf-plugin-system-upgrade

dnf -y system-upgrade download --releasever=27

dnf -y system-upgrade reboot

EOT

# set permission to allow executing script
chmod u+x ~/ZEC/fedora_upgrade.sh

# create gui.py ... this can be executed from ~/ZEC/gui.py
echo -e "create gui.py ... this can be started from ~/ZEC/gui.py\n\n"
cat <<EOT >> ~/ZEC/gui.py
#!/usr/bin/python
# -*- coding: utf-8 -*-
import os
import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

class ourwindow(Gtk.Window):
    
    def __init__(self):
        Gtk.Window.__init__(self, title="Miner GUI")
        Gtk.Window.set_default_size(self, 100,325)
        Gtk.Window.set_position(self, Gtk.WindowPosition.CENTER)
        
        self.set_border_width(10)
        hbox = Gtk.Box(spacing=6)
        self.add(hbox)

        # define button 1 parameter        
        button1 = Gtk.Button("Run miner pool config script")
        button1.connect("clicked", self.whenbutton1_clicked)
        self.add(button1)
        hbox.pack_start(button1, True, True, 0)


        # define button 2 parameter        
        button2 = Gtk.Button("Upgrade to Fedora 27")
        button2.connect("clicked", self.whenbutton2_clicked)
        self.add(button2)
        hbox.pack_start(button2, True, True, 0)       

    # action for button 1 when clicked
    def whenbutton1_clicked(self, button):
        print "running miner pool config script ..."
        os.system('./miner_pool_config.sh && exit')

    # action for button 2 when clicked
    def whenbutton2_clicked(self, button):
        print "Upgrading to Fedora 27..."
        os.system('./fedora_upgrade.sh && exit')

window = ourwindow()        
window.connect("delete-event", Gtk.main_quit)
window.show_all()
Gtk.main()

EOT

# set permission to allow executing script
chmod u+x ~/ZEC/gui.py

### FINAL STEP
### execute nvidia config script and reboot system
echo -e "executing nvidia config script and reboot system...\n\nsudo required\n" 
sudo -E ~/ZEC/nvidia_config.sh
