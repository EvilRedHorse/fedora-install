#!/bin/bash

# this script installs GCC 4.9.3 
# to use it navigate to your home directory and type:
# sh install-gcc-4.9.3.sh

# download and install gcc 4.9.3
wget https://ftp.gnu.org/gnu/gcc/gcc-4.9.3/gcc-4.9.3.tar.gz
tar xzf gcc-4.9.3.tar.gz
cd gcc-4.9.3
./contrib/download_prerequisites
cd ..
mkdir objdir

cd objdir
../gcc-4.9.3/configure --prefix=$HOME/gcc-4.9.3 --enable-languages=c,c++,fortran,go --disable-multilib
make

# install
make install

# clean up
rm -rf ~/objdir
rm -f ~/gcc-4.9.3.tar.gz

# add to path (you may want to add these lines to $HOME/.bash_profile)
export PATH=$HOME/gcc-4.9.3/bin:$PATH
export LD_LIBRARY_PATH=$HOME/gcc-4.9.3/lib:$HOME/gcc-4.9.3/lib64:$LD_LIBRARY_PATH
