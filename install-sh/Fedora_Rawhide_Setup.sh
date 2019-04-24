#!/bin/bash
# author: EvilRedHorse
# name: Fedora_Rawhide_Setup.sh
# usage: Post-Installation Fedora Setup eg. network, selinux, samba, mail, web, database, torrent, virtd 

printf "Setting Network Address\n"
#Using sed for ifcfg-eth0
sed -i '/^NM_CONTROLLED="yes"/ a\
BROADCAST=192.168.1.255\
IPADDR0=192.168.1.105\
PREFIX0=24\
GATEWAY0=192.168.1.100\
DNS1=216.254.136.227\
DNS2=216.254.141.13\
IPV6_PEERDNS=yes\
IPV6_PEERROUTES=yes\

' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i '/^BOOTPROTO="dhcp"/ c\BOOTPROTO="static"' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i '/^ONBOOT/ c\ONBOOT="yes"' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i '/^/ a\
nameserver 192.168.1.50\
nameserver 208.72.120.204\
nameserver 216.254.141.13
' /etc/resolv.conf


printf "Writing IPTABLES\n"
#Using sed for iptables
sed -i '/^-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT/ a\
-A INPUT -m state --state NEW -m tcp -p tcp --dport 53 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 53 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 25 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 5353 -d 224.0.0.251 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 631 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 631 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 631 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 137 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 138 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 139 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 445 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 110 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 110 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 143 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 143 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 3306 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 5900 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 5900 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 5901 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 5901 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 5902 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 5902 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 5990 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 5990 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 9091 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 16509 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 16514 -j ACCEPT \
-A INPUT -m state --state NEW -m udp -p udp --dport 55200 -j ACCEPT \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 55200 -j ACCEPT
' /etc/sysconfig/iptables
systemctl restart iptables.service

printf "Enabling RPM Fusion Repos\n"
yum localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm
yum localinstall --nogpgcheck http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-stable.noarch.rpm

# printf "Updating to Rawhide\n"
# yum -y install fedora-release-rawhide

# setup mysqld service
printf "Installing MySQL Database/n"
yum -y groupinstall 'MySQL Database'
systemctl 'enable' mysqld.service
systemctl start mysqld.service
# prepare databases
printf "pass?"
read -s PASSWORD
mysql_install_db
mysqladmin -u root password "$PASSWORD"
mysql_secure_installation

#mysql comment_app < /var/www/html/comments/comments.sql
#mysql tblIADT < /var/www/html/info/tblIADT_Proper.sql

# Add Users
printf "IADT pass?"
read -s PASS2
useradd admin -c "It's A Dog Thing\!" -s /sbin/nologin -N -d /home/.admin -p $PASS2
useradd	care -c "It's A Dog Thing\!" -s /sbin/nologin -N -d /home/.care -p $PASS2
useradd	info -c "It's A Dog Thing\!" -s /sbin/nologin -N -d /home/.info -p $PASS2
useradd	KC -c "KC" -s /bin/bash -N -d /home/KC
useradd	smc -c "smc" -s /bin/bash -N -d /home/smc

printf "Enter KC passwords\n"
su -l KC -c passwd
su -l KC -c vncpasswd

printf "Enter smc passwords\n"
su -l smc -c passwd
su -l smc -c vncpasswd


# yum -y groupinstall 'Base'
# yum -y groupinstall 'System Tools'
printf "Installing Development Tools\n"
yum -y groupinstall 'Development Tools'
printf "Installing Development Libraries\n"
yum -y groupinstall 'Development Libraries'

# install kernel headers and libraries for VMware tools
# printf "install VMWare Tools"
# mkdir /media/cdrom
# mount /dev/cdrom /media/cdrom
# cp /media/cdrom/VM* /tmp
# tar -zxvf /tmp/VM* /tmp
# yum -y update kernel
yum -y install kernel-headers kernel-devel make
yum -y install gcc
# svn checkout svn://gcc.gnu.org/svn/gcc/trunk /opt/build/gcc
# /tmp/vm*/vmware-install.pl

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
setsebool -P global_ssp 1
setsebool -P qemu_full_network 1
setsebool -P sshd_forward_ports 1
setsebool -P wine_mmap_zero_ignore 1

printf "Enabling Printer Support\n"
yum -y groupinstall 'Printing Support'
printf "Configuring Samba\n"
yum -y groupinstall 'Directory Server'
yum -y groupinstall 'Windows File Server'
#using sed for smb.conf
sed -i '/workgroup = / c\      workgroup = MSHOME' /etc/samba/smb.conf
sed -i '/netbios name = / c\      netbios name = F16SERVER' /etc/samba/smb.conf
sed -i '/interfaces = / c\      interfaces = lo eth0 192.168.1.105/24' /etc/samba/smb.conf
sed -i '/hosts allow = / c\      hosts allow = 127. 192.168. 169.' /etc/samba/smb.conf
sed -i '/security = / c\      security = share' /etc/samba/smb.conf
sed -i '/passdb backend = / c\      passdb backend = smbpasswd' /etc/samba/smb.conf
sed -i '/wins server = / c\      wins server = 192.168.1.95' /etc/samba/smb.conf
systemctl restart iptables.service
systemctl 'enable' smb.service
systemctl 'enable' nmb.service

# setup httpd service
printf "Installing Web Server/n"
yum -y groupinstall 'Web Server'
systemctl 'enable' httpd.service
sed -i '/^Listen / c\Listen 192.168.1.105:80' /etc/httpd/conf/httpd.conf
sed -i '/^ServerAdmin / c\ServerAdmin admin@itsadogthing.ca' /etc/httpd/conf/httpd.conf
sed -i '/^#ServerName / c\ServerName www.itsadogthing.ca:80' /etc/httpd/conf/httpd.conf
sed -i '/^DirectoryIndex / c\DirectoryIndex index.php index.html index.html.var' /etc/httpd/conf/httpd.conf

printf "consider modifying /etc/php.ini"

# setup transmission-daemon service
printf "/Installing Transmission-Daemon/n"
yum -y install transmission-daemon
systemctl 'enable' transmission-daemon.service
systemctl start transmission-daemon.service
systemctl stop transmission-daemon.service
sed -i '/rpc-whitelist-enabled/ c\    '\"'rpc-whitelist-enabled'\"': false,' /var/lib/transmission/.config/transmission/settings.json
sed -i '/peer-port/ c\    '\"'peer-port'\"': 55200,' /var/lib/transmission/.config/transmission/settings.json
sed -i '/utp-enabled/ c\    '\"'utp-enabled'\"': true,' /var/lib/transmission/.config/transmission/settings.json
sed -i '/script-torrent-done-enabled/ c\    '\"'script-torrent-done-enabled'\"': false,' /var/lib/transmission/.config/transmission/settings.json
sed -i '/script-torrent-done-filename/ c\    '\"'script-torrent-done-filename'\"': '\"''\"',' /var/lib/transmission/.config/transmission/settings.json
sed -i '/utp-enabled/ a\
    '\"'watch-dir'\"': '\"'/var/lib/transmission'\"',\
    '\"'watch-dir-enabled'\"': true
' /var/lib/transmission/.config/transmission/settings.json

# setup mail service
printf "Installing Mail Server/n"
yum -y groupinstall 'Mail Server'
systemctl 'enable' sendmail.service
systemctl 'enable' dovecot.service
systemctl 'enable' spamassassin.service
# write .conf files
systemctl stop sendmail.service
sed -i '/info/ c\#info:		postmaster' /etc/aliases
makemap hash /etc/aliases.db < /etc/aliases
sed -i '/^Connect:127.0.0.1/ a\
Connect:192.168.1.20               RELAY\
Connect:192.168.1.95               RELAY\
Connect:192.168.1.100              RELAY\
Connect:192.168.1.105              RELAY\
Connect:itsadogthing.ca            RELAY
' /etc/mail/access
makemap hash /etc/mail/access.db < /etc/mail/access
sed -i '/dnl define(`SMART_HOST'\'', `smtp.your.provider'\'')dnl/ c\define(`SMART_HOST'\'', `smtp.primus.ca'\'')dnl' /etc/mail/sendmail.mc
sed -i '/DAEMON_OPTIONS(`Port=smtp,Addr=127.0.0.1, Name=MTA'\'')dnl/ c\dnl # DAEMON_OPTIONS(`Port=smtp,Addr=127.0.0.1, Name=MTA'\'')dnl' /etc/mail/sendmail.mc
sed -i '/dnl DAEMON_OPTIONS(`Name=MTA-v4, Family=inet, Name=MTA-v6, Family=inet6'\'')/ c\DAEMON_OPTIONS(`Name=MTA-v4, Family=inet, Name=MTA-v6, Family=inet6'\'')' /etc/mail/sendmail.mc
sed -i '/dnl MASQUERADE_AS(`mydomain.com'\'')dnl/ c\MASQUERADE_AS(`itsadogthing.ca'\'')dnl' /etc/mail/sendmail.mc
sed -i '/MAILER(procmail)dnl/ a\MAILER(dovecot)dnl' /etc/mail/sendmail.cf
echo -n "# dovecot.m4" > /usr/share/sendmail-cf/mailer/dovecot.m4
sed -i '/^# dovecot.m4/ a\
Mdovecot,   P=/usr/libexec/dovecot/deliver, F=DFMPhnu9, \
            S=EnvFromSMTP/HdrFromSMTP, R=EnvToSMTP/HdrFromSMTP, \
            T=DNS/RFC822/X-Unix, \
            A=deliver -d $u
' /usr/share/sendmail-cf/mailer/dovecot.m4
m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf
sed -i '/#protocols = imap pop3 lmtp/ c\protocols = imap pop3 lmtp' /etc/dovecot/dovecot.conf
sed -i '/protocols = imap pop3 lmtp/ a\mail_location = mbox:~/mail:INBOX=/var/mail/%u \
disable_plaintext_auth = no \
mail_privileged_group = mail \
listen = * \

' /etc/dovecot/dovecot.conf

# setup libvirt install
# yum -y groupinstall Virtualization
# yum -y selinux-policy
# systemctl 'enable' libvirtd.service
# systemctl 'enable' libvirt-guests.service
# setup vm
# virt-install --connect qemu:///system --name IADT --ram 512 --os-type=windows --os-variant=winxp --disk /home/IADT.img,device=disk,format=raw --boot hd --accelerate --graphics vnc,port=5990,listen=0.0.0.0 --autostart --debug
# setup vnc server & xfce environment
# printf "Installing Xfce/n"
# yum -y groupinstall 'Xfce'

yum -y install tigervnc-server tigervnc-server-module
cp /lib/systemd/system/vncserver@.service /lib/systemd/system/vncserver@:1.service
cp /lib/systemd/system/vncserver@.service /lib/systemd/system/vncserver@:0.service
sed -i '/ExecStart=/sbin/runuser -l <USER> -c '\"'/usr/bin/vncserver %i'\"'/ c\ExecStart=/sbin/runuser -l KC -c '\"'/usr/bin/vncserver %i'\"' ' /lib/systemd/system/vncserver@:1.service
sed -i '/ExecStart=/sbin/runuser -l <USER> -c '\"'/usr/bin/vncserver %i'\"'/ c\ExecStart=/sbin/runuser -l smc -c '\"'/usr/bin/vncserver %i'\"' ' /lib/systemd/system/vncserver@:0.service
sed -i '/ExecStop=/sbin/runuser -l <USER> -c '\"'/usr/bin/vncserver -kill %i'\"'/ c\ExecStop=/sbin/runuser -l KC -c '\"'/usr/bin/vncserver -kill %i'\"' ' /lib/systemd/system/vncserver@:1.service
sed -i '/ExecStop=/sbin/runuser -l <USER> -c '\"'/usr/bin/vncserver -kill %i'\"'/ c\ExecStop=/sbin/runuser -l smc -c '\"'/usr/bin/vncserver -kill %i'\"' ' /lib/systemd/system/vncserver@:0.service

su -l KC -c echo -n "# xstartup" > /home/KC/.vnc/xstartup
sed -i '/^# xstartup/ a\
#!/bin/sh \
unset SESSION_MANAGER \
export VNCSESSION='\"'TRUE'\"' \
# vncconfig -iconic & \
xterm -geometry 80x24+10+10 -ls -title '\"'$VNCDESKTOP Desktop'\"' & \
startxfce4 \

#' /home/KC/.vnc/xstartup
chmod 775 /home/KC/.vnc/xstartup

su -l smc -c echo -n "# xstartup" > /home/smc/.vnc/xstartup
sed -i '/^# xstartup/ a\
#!/bin/sh \
unset SESSION_MANAGER \
export VNCSESSION='\"'TRUE'\"' \
# vncconfig -iconic & \
xterm -geometry 80x24+10+10 -ls -title '\"'$VNCDESKTOP Desktop'\"' & \
startxfce4 \

#' /home/smc/.vnc/xstartup
chmod 775 /home/smc/.vnc/xstartup

systemctl --system daemon-reload
systemctl enable vncserver@:1.service
systemctl enable vncserver@:0.service

yum -y install *wine*
# yum -y install --nogpgcheck *gecko*
# cd /home
# wget http://winezeug.googlecode.com/svn/trunk/install-wine-deps.sh
# chmod a+x install-wine-deps.sh
# yum -y install alsa-lib-devel.i686 alsa-lib-devel audiofile-devel.i686 audiofile-devel cups-devel.i686 cups-devel dbus-devel.i686 dbus-devel fontconfig-devel.i686 fontconfig-devel freetype.i686 freetype-devel.i686 freetype-devel giflib-devel.i686 giflib-devel lcms-devel.i686 lcms-devel libICE-devel.i686 libICE-devel libjpeg-turbo-devel.i686 libjpeg-turbo-devel libpng-devel.i686 libpng-devel libSM-devel.i686 libSM-devel libusb-devel.i686 libusb-devel libX11-devel.i686 libX11-devel libXau-devel.i686 libXau-devel libXcomposite-devel.i686 libXcomposite-devel libXcursor-devel.i686 libXcursor-devel libXext-devel.i686 libXext-devel libXi-devel.i686 libXi-devel libXinerama-devel.i686 libXinerama-devel libxml2-devel.i686 libxml2-devel libXrandr-devel.i686 libXrandr-devel libXrender-devel.i686 libXrender-devel libxslt-devel.i686 libxslt-devel libXt-devel.i686 libXt-devel libXv-devel.i686 libXv-devel libXxf86vm-devel.i686 libXxf86vm-devel mesa-libGL-devel.i686 mesa-libGL-devel mesa-libGLU-devel.i686 mesa-libGLU-devel ncurses-devel.i686 ncurses-devel openldap-devel.i686 openldap-devel openssl-devel.i686 openssl-devel zlib-devel.i686 pkgconfig sane-backends-devel.i686 sane-backends-devel xorg-x11-proto-devel glibc-devel.i686 prelink fontforge flex bison libstdc++-devel.i686 pulseaudio-libs-devel.i686 gnutls-devel.i686 libgphoto2-devel.i686 openal-soft-devel openal-soft-devel.i686 isdn4k-utils-devel.i686 gsm-devel.i686 samba-winbind libv4l-devel.i686 cups-devel.i686 libtiff-devel.i686 gstreamer-devel.i686 gstreamer-plugins-base-devel.i686 gettext-devel.i686 libmpg123-devel.i686
# yum -y install cups-devel fontconfig-devel freetype-devel gphoto2-devel isdn4k-utils-devel libjpeg-devel libpng-devel libxml2-devel libxslt-devel ncurses-devel openldap-devel openssl-devel sane-backends-devel XFree86-devel zlib-devel bison flex gcc prelink pkgconfig 

# yum -y --disablerepo=* --enablerepo=rawhide update --skip-broken

yum -y update

printf "Rebooting\n"
reboot
