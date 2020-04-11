#! /usr/bin/bash --posix
# OPENWRT_Prerequisite.sh
mkdir openwrt
su -c 'chmod 775 openwrt'
cd openwrt
svn co svn://svn.openwrt.org/openwrt/trunk/
cd trunk
su -c 'yum install asciidoc binutils bzip2 libgcj flex gcc-c++ gcc gawk gtk2-devel intltool zlib-devel make ncurses-devel openssl-devel patch perl-ExtUtils-MakeMaker rsync ruby sdcc unzip wget gettext libxslt git-core'
# install for x86_64 (gcc may be ok)
su -c 'yum install gcc.i686 libgcc.i686 glibc-devel.i686'
./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
make prereq
make menuconfig
make
