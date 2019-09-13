#!/bin/bash

clear
# IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
# if [[ "$IP" = "" ]]; then
IP=$(wget -4qO- "http://whatismyip.akamai.com/")
# fi

if [[ $(id -g) != "0" ]] ; then
    echo ""
    echo "Scrip : สั่งรูทคำสั่ง [ sudo -i ] ก่อนรันสคริปนี้  "
    echo ""
    exit
fi

if [[  ! -e /dev/net/tun ]] ; then
    echo "Scrip : TUN/TAP device is not available."
fi
cd
if [[ -e /etc/debian_version ]]; then
VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
fi


MYIP=$(wget -qO- ipv4.icanhazip.com);

clear
cd

echo ""
echo ""
echo "    =============== OS-32 & 64-bit =================    "
echo "    #                                              #    "
echo "    #       AUTOSCRIPT CREATED BY PIRAKIT          #    "
echo "    #      -----------About Us------------         #    "
echo "    #      OS  DEBIAN 7-8-9  OS  UBUNTU 14-16      #    "
echo "    #    Truemoney Wallet : 096-746-2978           #    "
echo "    #               { VPN / SSH }                  #    "
echo "    #                  NAMNUEA                     #    "
echo "    #         BY : Pirakit Khawpleum               #    "
echo "    #    FB : https://m.me/pirakrit.khawplum       #    "
echo "    #                                              #    "
echo "    =============== OS-32 & 64-bit =================    "
echo ""
echo "    ~¤~ ๏[-ิ_•ิ]๏ ~¤~ Admin MyGatherBK ~¤~ ๏[-ิ_•ิ]๏ ~¤~ "
echo ""
echo " ไอพีเซิฟ:$IP "
echo ""
echo ""

#install openvpn
ok "➡ apt-get update"
apt-get update -q > /dev/null 2>&1
ok "➡ apt-get install openvpn curl openssl"
apt-get install -qy openvpn curl > /dev/null 2>&1

# IP Address
SERVER_IP=$(wget -qO- ipv4.icanhazip.com);
if [[ "$SERVER_IP" = "" ]]; then
    SERVER_IP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
fi

wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/openvpn.tar"
wget -O /etc/openvpn/default.tar "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/default.tar"
cd /etc/openvpn/
tar xf openvpn.tar
tar xf default.tar
cp sysctl.conf /etc/
cp before.rules /etc/ufw/
cp ufw /etc/default/
rm sysctl.conf
rm before.rules
rm ufw
service openvpn restart

cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/client.ovpn"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /root/

#N | apt-get install ufw
ufw allow ssh
ufw allow 1194/tcp
ufw allow 8080/tcp
ufw allow 3128/tcp
ufw allow 80/tcp
yes | sudo ufw enable



if [[ "$VERSION_ID" = 'VERSION_ID="7"' || "$VERSION_ID" = 'VERSION_ID="8"' || "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
#install squid3
ok "➡ apt-get install squid3"
apt-get install -qy squid3 > /dev/null 2>&1
cp /etc/squid3/squid.conf /etc/squid3/squid.conf.orig
echo "http_port 8080
http_port 3128
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst $SERVER_IP-$SERVER_IP/255.255.255.255                 
http_access allow SSH
http_access allow localnet
http_access allow localhost
http_access deny all
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320" > /etc/squid3/squid.conf
ok "➡ service squid3 restart"
service squid3 restart -q > /dev/null 2>&1

elif [[ "$VERSION_ID" = 'VERSION_ID="16.04"' || "$VERSION_ID" = 'VERSION_ID="9"' ]]; then
#install squid3
ok "➡ apt-get install squid"
apt-get install -qy squid > /dev/null 2>&1
cp /etc/squid/squid.conf /etc/squid/squid.conf.orig
cat > /etc/squid/squid.conf <<END
http_port 8080
http_port 3128
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst $SERVER_IP-$SERVER_IP/255.255.255.255
http_access allow SSH
http_access allow localnet
http_access allow localhost
http_access deny all
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
END
ok "➡ service squid restart"
service squid restart -q > /dev/null 2>&1
fi



#install Nginx
ok "➡ apt-get install nginx"
	apt-get -y install nginx
	cat > /etc/nginx/nginx.conf <<END
user www-data;
worker_processes 2;
pid /var/run/nginx.pid;
events {
	multi_accept on;
        worker_connections 1024;
}
http {
	autoindex on;
        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        server_tokens off;
        include /etc/nginx/mime.types;
        default_type application/octet-stream;
        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;
        client_max_body_size 32M;
	client_header_buffer_size 8m;
	large_client_header_buffers 8 8m;
	fastcgi_buffer_size 8m;
	fastcgi_buffers 8 8m;
	fastcgi_read_timeout 600;
        include /etc/nginx/conf.d/*.conf;
}
END
	mkdir -p /home/vps/public_html
	echo "<pre>Source by Mnm Ami | Donate via TrueMoney Walle 096-746-2879 </pre>" > /home/vps/public_html/index.html
	echo "<?phpinfo(); ?>" > /home/vps/public_html/info.php
	args='$args'
	uri='$uri'
	document_root='$document_root'
	fastcgi_script_name='$fastcgi_script_name'
	cat > /etc/nginx/conf.d/vps.conf <<END
server {
    listen       85;
    server_name  127.0.0.1 localhost;
    access_log /var/log/nginx/vps-access.log;
    error_log /var/log/nginx/vps-error.log error;
    root   /home/vps/public_html;
    location / {
        index  index.html index.htm index.php;
	try_files $uri $uri/ /index.php?$args;
    }
    location ~ \.php$ {
        include /etc/nginx/fastcgi_params;
        fastcgi_pass  127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
END
ok "➡ service nginx restart"

# download script
cd /usr/bin
wget -q -O z "https://raw.githubusercontent.com/MyGatherBk/aungwin/master/menu"
wget -q -O speedtest "https://raw.githubusercontent.com/MyGatherBk/aungwin/master/speedtest"
wget -q -O b-user "https://raw.githubusercontent.com/MyGatherBk/aungwin/master/b-user"


echo "30 3 * * * root /sbin/reboot" > /etc/cron.d/reboot
chmod +x speedtest
chmod +x z
chmod +x b-user
service cron restart -q > /dev/null 2>&1

# info
clear
echo "OpenSSH  : 22 " 
echo "Proxy    : 3128, 8080  
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:85/root/client.ovpn)" 
echo "nginx    : 85"  
echo "Script menu  : menu Script " 
cd
rm -f pirakit
rm -f /root/pirakit
printf 'nคุณจำเป็นต้องรีสตาร์ทระบบหนึ่งรอบ (y/n):'
read a
if [ $a == 'y' ]
then
reboot
else
exit
fi
