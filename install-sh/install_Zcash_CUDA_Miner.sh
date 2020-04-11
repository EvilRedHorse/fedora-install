#! /usr/bin/bash --posix

echo -e "Downloading miner and extracting..."
wget -qO- https://github.com/nanopool/ewbf-miner/releases/download/v0.3.4b/Zec.miner.0.3.4b.Linux.Bin.tar.gz | tar xvz miner 
mkdir ~/Public/Zcash
cp miner ~/Public/Zcash
chmod u+x ~/Public/Zcash/miner
rm miner
# create miner start script
echo -e "\ncreate miner start script...\n\n"
cat <<EOT >> ~/Public/Zcash/start_miner.sh

#! /usr/bin/bash --posix

# start miner
sudo -E ~/Public/Zcash/miner  --eexit 1 --config ~/Public/Zcash/intensity.cfg
EOT

# set permission to allow executing script
chmod u+x ~/Public/Zcash/start_miner.sh


# create miner config file
echo -e "\ncreate default miner config file...\n\n"
cat <<EOT >> ~/Public/Zcash/intensity.cfg
# miner config file

[common]
solver 0
fee 000
cuda_devices 0
intensity    50
templimit    80
pec          0

[server]
server pool.equihash.ca
port   4434
user   t1UpTopzDnoB1WBt53H4w39TftGrQjgaKE5.workerX
pass   x

EOT
# set permission to allow reading config
chmod u+r ~/Public/Zcash/intensity.cfg

echo -e "done"

