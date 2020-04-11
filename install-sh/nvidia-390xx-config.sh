#! /usr/bin/bash --posix
# install nvidia 390xx drivers

sudo dnf --nogpgcheck -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install kmod-nvidia-390xx xorg-x11-drv-nvidia-390xx akmod-nvidia-390xx "kernel-devel-uname-r == $(uname -r)" \
xorg-x11-drv-nvidia-390xx-cuda xorg-x11-drv-nvidia-390xx-libs.i686 xorg-x11-drv-nvidia-390xx-libs nvidia-xconfig nvidia-settings-390xx vdpauinfo libva-vdpau-driver libva-utils libcurl-devel openssl-devel libGLU-devel libXi-devel libXmu-devel

sudo dnf -y groupinstall "C Development Tools and Libraries"

sudo dnf -y install pitivi

echo -e "done"
