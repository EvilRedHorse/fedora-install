#! /usr/bin/bash --posix
# install nvidia 390xx drivers on fedora 41
# requires: dnf5

### colourize stream ###
# start RED text: ${RED}
RED=$(tput setaf 1)
# start GREEN text: ${GREEN}
GREEN=$(tput setaf 2)
# start YELLOW text: ${YELLOW}
YELLOW=$(tput setaf 3)
# start OTHER text: ${OTHER}
OTHER=$(tput setaf 6)
# start PURPLE text: ${PURPLE}
PURPLE=$(tput setaf 125)
# end colour text: ${NORMAL}
NORMAL=$(tput sgr0)

# install tools for building kernel modules
printf "${YELLOW}Installing C Dev Tools & Lib... \n${NORMAL}"
sudo -S dnf -y group install c-development
sudo -S dnf -y install libcurl-devel openssl-devel libGLU-devel libXi-devel libXmu-devel 

# install rpmfusion repos
printf "${OTHER}Installing rpmfusion... \n${NORMAL}"
sudo -S dnf --nogpgcheck -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo -S dnf --nogpgcheck -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# install nvidia firmware & drivers
printf "${GREEN}Installing Nvidia Drivers... \n${NORMAL}"
sudo -S dnf -y install nvidia-gpu-firmware libva-nvidia-driver
sudo -S dnf -y install "kernel-devel-$(uname -r)" libva-utils akmod-nvidia-390xx.x86_64 nvidia-settings-390xx.x86_64 xorg-x11-drv-nvidia-390xx.x86_64 xorg-x11-drv-nvidia-390xx-cuda.x86_64 xorg-x11-drv-nvidia-390xx-cuda-libs.i686 xorg-x11-drv-nvidia-390xx-cuda-libs.x86_64 xorg-x11-drv-nvidia-390xx-devel.x86_64 xorg-x11-drv-nvidia-390xx-kmodsrc.x86_64 xorg-x11-drv-nvidia-390xx-libs.i686 xorg-x11-drv-nvidia-390xx-libs.x86_64

# build kmod-nvidia
printf "${GREEN}Build kmod for Nvidia Drivers after creating certs/keypair... \n${NORMAL}"
sudo kmodgenca -a
sudo akmods --force --rebuild --kernels $( uname -r )

# kmod config
printf "${OTHER}Disable nouveau & enable nvidia modules... \n${NORMAL}"
sudo grubby --update-kernel=ALL --args='nvidia-drm.modeset=1'
sudo grubby --update-kernel=ALL --args='modprobe.blacklist=nouveau'
sudo grubby --update-kernel=ALL --args='rd.driver.blacklist=nouveau'

# MOK config
printf "${PURPLE}Get MOK to register new keypair, On next boot MOK Management is launched, choose Enroll MOK. Choose Continue to enroll the key. Confirm enrollment by selecting Yes. Enter the password generated above.... \n${NORMAL}"
sudo mokutil --import /etc/pki/akmods/certs/public_key.der

# reboot
printf "${PURPLE}Reboot now... \n${NORMAL}"
#sudo reboot

