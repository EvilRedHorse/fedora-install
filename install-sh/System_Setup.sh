#!/bin/bash
# author: EvilRedHorse
# name: System_Setup.sh
# usage: Post-Installation Fedora Setup eg. selinux, vlc, samba

printf "Setting SE Linux Booleans\n"
setsebool -P samba_domain_controller on
setsebool -P samba_enable_home_dirs on
setsebool -P samba_export_all_rw on
setsebool -P samba_share_fusefs on
setsebool -P httpd_read_user_content 1
setsebool -P httpd_can_sendmail 1
setsebool -P httpd_enable_homedirs 1
setsebool -P allow_httpd_anon_write 1
setsebool -P httpd_can_network_connect_db 1
setsebool -P use_samba_home_dirs 1
setsebool -P logging_syslogd_can_sendmail 1
setsebool -P mysql_connect_any 1
setsebool -P allow_user_mysql_connect 1

printf "Installing VLC Media Player\n"
yum localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm
yum localinstall --nogpgcheck http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-stable.noarch.rpm
yum -y install vlc

printf "Enabling Samba"
#Using sed for iptables
sed -i '/^-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT/ a\
-A INPUT -m state --state NEW -m tcp -p tcp --dport 53 -j ACCEPT\
-A INPUT -m state --state NEW -m udp -p udp --dport 53 -j ACCEPT\
-A INPUT -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPT\
-A INPUT -m state --state NEW -m udp -p udp --dport 5353 -d 224.0.0.251 -j ACCEPT\
-A INPUT -m state --state NEW -m udp -p udp --dport 631 -j ACCEPT\
-A INPUT -m state --state NEW -m tcp -p tcp --dport 631 -j ACCEPT\
-A INPUT -m state --state NEW -m udp -p udp --dport 631 -j ACCEPT\
-A INPUT -m state --state NEW -m udp -p udp --dport 137 -j ACCEPT\
-A INPUT -m state --state NEW -m udp -p udp --dport 138 -j ACCEPT\
-A INPUT -m state --state NEW -m tcp -p tcp --dport 139 -j ACCEPT\
-A INPUT -m state --state NEW -m tcp -p tcp --dport 445 -j ACCEPT\
-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT\
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT\
-A INPUT -m state --state NEW -m tcp -p tcp --dport 9091 -j ACCEPT
' /etc/sysconfig/iptables


#using sed for smb.conf
sed -i '/^workgroup =/ c\	workgroup = MSHOME' /etc/samba/smb.conf
sed -i '/^netbios name =/ c\	netbios name = AMD64' /etc/samba/smb.conf
sed -i '/^interfaces =/ c\	interfaces = lo eth0 192.168.1.22/24' /etc/samba/smb.conf
sed -i '/^hosts allow =/ c\	hosts allow = 127. 192.168. 169.' /etc/samba/smb.conf
sed -i '/^security =/ c\	security = share' /etc/samba/smb.conf
sed -i '/^passdb backend =/ c\	passdb backend = smbpasswd' /etc/samba/smb.conf
sed -i '/^wins server =/ c\	wins server = 192.168.1.95' /etc/samba/smb.conf
systemctl restart iptables.service
systemctl 'enable' smb.service
systemctl 'enable' nmb.service
systemctl start nmb.service
systemctl start smb.service

printf "Update System\n"
yum -y update

printf "Reboot\n"
reboot

