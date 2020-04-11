#! /usr/bin/bash --posix
# Fedora just CPU
sudo dnf -y install gcc gcc-c++ hwloc-devel libmicrohttpd-devel libstdc++-static make openssl-devel cmake
git clone https://github.com/fireice-uk/xmr-stak.git ~/Public/xmr-stak
# Change donate levels
sed -i '/constexpr double fDevDonationLevel = 2.0 \/ 100.0;/ c\constexpr double fDevDonationLevel = 0.0 \/ 100.0;' ~/Public/xmr-stak/xmrstak/donate-level.hpp
mkdir ~/Public/xmr-stak/build
cd ~/Public/xmr-stak/build
#cmake -DOpenCL_ENABLE=OFF ..
cmake -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=ON ..
make install
echo -e "done"

