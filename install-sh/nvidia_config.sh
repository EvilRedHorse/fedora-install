#! /usr/bin/bash --posix
# install nvidia drivers

sudo dnf --nogpgcheck -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf -y install kmod-nvidia xorg-x11-drv-nvidia akmod-nvidia "kernel-devel-uname-r == $(uname -r)"

sudo dnf -y install xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-libs

sudo dnf -y install vdpauinfo libva-vdpau-driver libva-utils

sudo dnf -y groupinstall "C Development Tools and Libraries"

sudo dnf -y install libcurl-devel openssl-devel

sudo dnf -y install libGLU-devel libXi-devel libXmu-devel

sudo dnf -y install pitivi

sudo dnf -y install nvidia-xconfig

echo -e "done"
