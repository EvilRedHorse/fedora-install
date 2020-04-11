#! /usr/bin/bash --posix

# Update dnf based system, grouping packages: kernel | other | cuda & nvidia

_dnf () {
# set to exit on error 
set -o errexit

### colourize stream ###
# start RED text: ${RED}
RED=$(tput setaf 1)
# start GREEN text: ${GREEN}
GREEN=$(tput setaf 2)
# start YELLOW text: ${YELLOW}
YELLOW=$(tput setaf 3)
# start PURPLE text: ${PURPLE}
PURPLE=$(tput setaf 125)
# end colour text: ${NORMAL}
NORMAL=$(tput sgr0)

printf "${GREEN}\nUpdating kernel packages... \n${NORMAL}"
sudo dnf -y update kernel kernel-core kernel-devel kernel-headers kernel-modules kernel-modules-extra

printf "${YELLOW}\nUpdating available packages,\nskipping kernel, cuda & nvidia... \n${NORMAL}"
sudo dnf -y --exclude=kernel*  --exclude=*nvidia* --exclude=*cuda* update

printf "${PURPLE}\nSync nvidia & cuda... \n${NORMAL}"
sudo dnf -y  --exclude=kernel* distrosync *cuda* *nvidia*

# The below packages are often updated but wildcards for nvidia & cuda are more flexible  
# akmod-nvidia.x86_64 kmod-nvidia.x86_64 nvidia-persistenced.x86_64 nvidia-settings.x86_64 nvidia-xconfig.x86_64 xorg-x11-drv-nvidia.x86_64 xorg-x11-drv-nvidia-cuda.x86_64 xorg-x11-drv-nvidia-cuda-libs.i686 xorg-x11-drv-nvidia-cuda-libs.x86_64 xorg-x11-drv-nvidia-kmodsrc.x86_64 xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-libs.x86_64 nvidia-driver-cuda.x86_64 nvidia-driver-cuda-libs.x86_64
printf "${RED}\nEnd\n${NORMAL}"
}
_dnf


