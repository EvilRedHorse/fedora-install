#! /usr/bin/sh
# Update 

echo "
Update kernel packages ...
"
sudo dnf update kernel**********

echo "
Update most available package ...
"
sudo dnf --exclude=kernel*  --exclude=*nvidia* --exclude=*cuda* update

echo "Sync nvidia"
sudo dnf --exclude=kernel* distrosync  *nvidia*

#echo "Sync cuda"
#sudo dnf --exclude=kernel* distrosync *cuda* 


