#!/bin/bash
#PIRAKIT-VPN

read -p " ใส่ผู้ใช้ที่จะลบ : " Nama
userdel -r $Nama
exit
;;

20 )
cd /usr/bin
#PIRAKIT-VPN
cp /etc/openvpn/1194.conf /home/1194ori.conf

sed -i 's|1194|443|' /etc/openvpn/1194.conf

service openvpn start

ufw allow 443/tcp
ufw allow 443/udp
ufw allow 444/tcp
ufw allow 444/udp

ufw enable

ufw status
ufw disable

sed -i 's/DROPBEAR_PORT=443/DROPBEAR_PORT=444/g' /etc/default/dropbear

sed -i 's/443/444/g' /etc/default/dropbear

service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service squid3 restart
cd