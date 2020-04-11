#! /usr/bin/bash --posix

# script to install rtl8812au drivers using dmks


#install dkms kernel-devel kernel-headers
sudo dnf install dkms "kernel-devel-uname-r == $(uname -r)" kernel-headers

# Fetch drivers
git clone https://github.com/abperiasamy/rtl8812AU_8821AU_linux.git

# Move into build folder
cd rtl8812AU_8821AU_linux

# Build with dkms
sudo make -f Makefile.dkms install







