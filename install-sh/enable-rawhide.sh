#! /usr/bin/bash --posix

printf "installing repos for rawhide\n"
sudo dnf -y install fedora-repos-rawhide rpmfusion-nonfree-release-rawhide.noarch rpmfusion-free-release-rawhide.noarch
