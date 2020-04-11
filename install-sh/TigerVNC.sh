#! /usr/bin/bash --posix
# author: EvilRedHorse
# name: TigerVNC.sh

su -l smc -c vncpasswd

yum -y install tigervnc-server tigervnc-server-module

cp /lib/systemd/system/vncserver@.service /lib/systemd/system/vncserver@:0.service

sed -i '/ExecStart=/sbin/runuser -l <USER> -c '\"'/usr/bin/vncserver %i'\"'/ c\ExecStart=/sbin/runuser -l smc -c '\"'/usr/bin/vncserver %i'\"' ' /lib/systemd/system/vncserver@:0.service

sed -i '/ExecStop=/sbin/runuser -l <USER> -c '\"'/usr/bin/vncserver -kill %i'\"'/ c\ExecStop=/sbin/runuser -l smc -c '\"'/usr/bin/vncserver -kill %i'\"' ' /lib/systemd/system/vncserver@:0.service

su -l smc -c echo -n "
#!/bin/sh
unset SESSION_MANAGER
export VNCSESSION=\"TRUE\"
# vncconfig -iconic &
xterm -geometry 80x24+10+10 -ls -title \"$VNCDESKTOP Desktop\" &
startxfce4
" > /home/smc/.vnc/xstartup
chmod 775 /home/smc/.vnc/xstartup
systemctl --system daemon-reload
systemctl enable vncserver@:0.service
