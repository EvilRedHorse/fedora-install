#! /usr/bin/bash --posix
# install nvidia 390xx drivers
# requires: kdialog

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


#SUDO_PASS=`kdialog --password "Enter password to start: "`

dbusRef=`kdialog --progressbar "Initializing" 4`

printf "${OTHER}Installing rpmfusion... \n${NORMAL}"
sudo dnf --nogpgcheck -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
qdbus $dbusRef Set "" value 1

printf "${GREEN}Installing Nvidia Drivers... \n${NORMAL}"
sudo dnf -y install kmod-nvidia-390xx xorg-x11-drv-nvidia-390xx akmod-nvidia-390xx "kernel-devel-uname-r == $(uname -r)" xorg-x11-drv-nvidia-390xx-cuda xorg-x11-drv-nvidia-390xx-libs.i686 xorg-x11-drv-nvidia-390xx-libs nvidia-xconfig nvidia-settings-390xx vdpauinfo libva-vdpau-driver libva-utils libcurl-devel openssl-devel libGLU-devel libXi-devel libXmu-devel
qdbus $dbusRef Set "" value 2

printf "${YELLOW}Installing C Dev Tools & Lib... \n${NORMAL}"
sudo dnf -y groupinstall "C Development Tools and Libraries"
qdbus $dbusRef Set "" value 3

printf "${PURPLE}Installing pitivi... \n${NORMAL}"
sudo dnf -y install pitivi
qdbus $dbusRef Set "" value 4

printf "${RED}done\n${NORMAL}"
sleep 3
qdbus $dbusRef close

