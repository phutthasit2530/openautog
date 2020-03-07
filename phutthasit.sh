
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

cd

MYIP=$(wget -qO- ipv4.icanhazip.com);


clear
cd
echo

# Color
GRAY='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'
YELLOW='\033[33;1m'
RED='\033[31;1m'
BLUE='\033[34;1m'
MAGENTA='\033[35;1m'
CYAN='\033[36;1m'

# Functions
z1='\e[31;1m'  #red
z2='\e[34;1m'  #blue
z3='\e[32;1m'  #green
z4='\e[35;1m'  #magenta
z5='\e[36;1m'  #cyan
z6='\e[33;1m'  #yellow
z7='\e[0m'

ok() {
    echo -e '\e[32m'$1'\e[m';
}

die() {
    echo -e '\e[1;35m'$1'\e[m';
}
red() {
    echo -e '\e[1;31m'$1'\e[m';
}

des() {
    echo -e '\e[1;31m'$1'\e[m'; exit 1;
}


#
#<BODY text='ffffff'>

if [[ -d /etc/openvpn ]]; then
clear
cd
echo
    ok " Script : ได้ติดตั้ง openvpn ใว้แล้วก่อนหน้านี้  ."
    ok " Script : ต้องการติดตั้งทับหรือไม่ ฟังชั่นบางบางอาจไม่ทำงาน "
    read -p " Script y/n : " -e -i y enter
 if [[ $enter = y || $enter = Y ]]; then
 clear
cd
echo
else
clear
cd
echo
exit
fi
else
clear
cd
echo
fi

clear

# ads
echo ""
echo ""
echo -e "\033[1;31m  =============== OS-32 & 64-bit =================    "
echo -e "\033[1;31m  #                                              #    "
echo -e "\033[1;31m  #        AUTOSCRIPT ─━═हຫມາສີ້ແມ່ມືງह═━─          #    "
echo -e "\033[1;31m  #      -----------About Us------------         #    "
echo -e "\033[1;31m  #       OS  Debian 8-9  OS  Ubuntu 14-16       #    "
echo -e "\033[1;31m  #               { VPN / SSH }                  #    "
echo -e "\033[1;31m  #         BY : ─━═हຫມາສີ້ແມ່ມືງह═━─               #    "
echo -e "\033[1;31m  =============== OS-32 & 64-bit =================    "
echo -e "\033[1;36m  ไอพีเซิฟ:$IP "
echo -e "\033[0m       "
echo ""
# Install openvpn
cd
echo "
----------------------------------------------
[√] ระบบสคริป  : Pirakit Khawpleum 
[√] กรุณารอสักครู่ .....
[√] Loading .....
----------------------------------------------
 "
ok "➡ apt-get update "
apt-get update -q > /dev/null 2>&1
ok "➡ apt-get install openvpn curl openssl "
apt-get install -qy openvpn curl > /dev/null 2>&1

# IP Address
SERVER_IP=$(wget -qO- ipv4.icanhazip.com);
if [[ "$SERVER_IP" = "" ]]; then
    SERVER_IP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | grep -v '192.168'`;
fi

ok "➡ Generating CA Config "
cd /
wget -q -O ovpn.tar "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/openvpn.tar"
tar xf ovpn.tar
rm ovpn.tar

cat > /etc/openvpn/Dtacไวเบอร์.ovpn << Dtacไวเบอร์
client
dev tun
proto tcp
remote ไวเบอร์ 999 udp
remote $SERVER_IP:1194@www.viber.com
http-proxy $SERVER_IP 8080
http-proxy-option CUSTOM-HEADER Host:www.viber.com
http-proxy-timeout 5
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3
Dtacไวเบอร์

cat > /etc/openvpn/Trueid.ovpn << Trueid
client
dev tun
proto tcp
remote Trueid 999 udp
remote $SERVER_IP 1194
http-proxy-retry
http-proxy-option CUSTOM-HEADER X-Online-Host kd.truevisions.tv
http-proxy $SERVER_IP 8080
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3
Trueid

cat > /etc/openvpn/Dtacโซเชี่ยว.ovpn << Dtacโซเชี่ยว
client
dev tun
proto tcp
remote โซเชี่ยว 999 udp
remote $SERVER_IP:1194@kd.truevisions.tv.line.naver.jp
http-proxy $SERVER_IP 8080
http-proxy-option CUSTOM-HEADER Host:api.twitter.com
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3
Dtacโซเชี่ยว

cat > /etc/openvpn/faceline.ovpn << faceline
client
dev tun
proto tcp
remote face+line 999 udp
remote $SERVER_IP 443
http-proxy-retry
http-proxy 10.4.4.4 8080
http-proxy-option CUSTOM-HEADER "Host: line.naver.jp
http-proxy-option CUSTOM-HEADER "X-Online-Host: line.naver.jp
http-proxy-option CUSTOM-HEADER "X-Forward-Host: line.naver.jp
http-proxy-option CUSTOM-HEADER "X-Forwarded-For: line.naver.jp
http-proxy-option CUSTOM-HEADER "Referer: line.naver.jp
http-proxy-option CUSTOM-HEADER "Connection: keep-alive"
http-proxy-option CUSTOM-HEADER "Proxy-Connection: keep-alive"
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3
faceline

cat > /etc/openvpn/Trueปลูกปัญญา.ovpn << Trueปลูกปัญญา
client
dev tun
proto tcp
remote Trueปลูกปัญญา 999 udp
remote $SERVER_IP:1194@th.m.wikipedia.org
http-proxy-retry
http-proxy-option CUSTOM-HEADER X-Online-Host th.m.wikipedia.org
http-proxy $SERVER_IP 8080
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3
Trueปลูกปัญญา

cat > /etc/openvpn/AIS64kbps.ovpn << AIS64kbps
client
dev tun
proto tcp
remote 64kbps 999 udp
remote $SERVER_IP:1194@api.ais.co.th
http-proxy $SERVER_IP 8080
http-proxy-option CUSTOM-HEADER Host t.co
http-proxy-timeout 5
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3
AIS64kbps

cat > /etc/openvpn/hanoi.ovpn << hanoi
client
dev tun
proto tcp
remote $SERVER_IP 1194
http-proxy $SERVER_IP 8080
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3
hanoi

cat > /etc/openvpn/aisplay.ovpn << aisplay
client
dev tun
proto tcp
remote aisplay 999 udp
remote $SERVER_IP:1194@play.ais.co.th
http-proxy-option CUSTOM-HEADER Host api.ais.co.th
http-proxy $SERVER_IP 8080
connect-retry 1
connect-timeout 120
resolv-retry infinite
route-method exe
nobind
ping 5
ping-restart 30
persist-key
persist-tun
persist-remote-ip
mute-replay-warnings
verb 3
cipher none
comp-lzo
script-security 3
aisplay

# Restart Service
ok "➡ service openvpn restart "
service openvpn restart > /dev/null 2>&1

if [[ "$VERSION_ID" = 'VERSION_ID="7"' || "$VERSION_ID" = 'VERSION_ID="8"' || "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
#install squid3
ok "➡ apt-get install squid3 "
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
ok "➡ service squid3 restart "
service squid3 restart -q > /dev/null 2>&1

elif [[ "$VERSION_ID" = 'VERSION_ID="16.04"' || "$VERSION_ID" = 'VERSION_ID="9"' ]]; then
#install squid3
ok "➡ apt-get install squid "
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
ok "➡ service squid restart "
service squid restart -q > /dev/null 2>&1
fi



#install Nginx
ok "➡ apt-get install nginx "
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
ok "➡ service nginx restart "

#install php-fpm
if [[ "$VERSION_ID" = 'VERSION_ID="7"' || "$VERSION_ID" = 'VERSION_ID="8"' || "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then

#debian8
ok "➡ apt-get install php "
apt-get install -qy php5-fpm > /dev/null 2>&1
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
apt-get install -qy php5-curl > /dev/null 2>&1
ok "➡ service php restart "
service php5-fpm restart -q > /dev/null 2>&1
elif [[ "$VERSION_ID" = 'VERSION_ID="9"' || "$VERSION_ID" = 'VERSION_ID="16.04"' ]]; then
#debian9 Ubuntu16.4
ok "➡ apt-get install php "
apt-get install -qy php7.0-fpm > /dev/null 2>&1
sed -i 's/listen = \/run\/php\/php7.0-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php/7.0/fpm/pool.d/www.conf
apt-get install -qy php7.0-curl > /dev/null 2>&1
ok "➡ service php restart "
service php7.0-fpm restart > /dev/null 2>&1
fi

# setting port ssh
cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 443' /etc/ssh/sshd_config
ok "➡ service ssh restart "
service ssh restart > /dev/null 2>&1

# install dropbear
ok "➡ apt-get install dropbear "
apt-get install -qy dropbear > /dev/null 2>&1
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=3128/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 143"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
ok "➡ service dropbear restart"
service dropbear restart > /dev/null 2>&1



# install stunnel
ok "➡ apt-get install ssl "
apt-get install -qy stunnel4 > /dev/null 2>&1
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
[stunnel]
accept = 444
connect = 127.0.0.1:22
END

#membuat sertifikat
cat /etc/openvpn/client-key.pem /etc/openvpn/client-cert.pem > /etc/stunnel/stunnel.pem

#konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
ok "➡ service ssl restart "
service stunnel4 restart > /dev/null 2>&1

# install vnstat gui
ok "➡ apt-get install vnstat "
apt-get install -qy php5-fpm > /dev/null 2>&1
chown -R vnstat:vnstat /var/lib/vnstat
cd /home/vps/public_html
wget -q http://www.sqweek.com/sqweek/files/vnstat_php_frontend-1.5.1.tar.gz
tar xf vnstat_php_frontend-1.5.1.tar.gz
rm vnstat_php_frontend-1.5.1.tar.gz
mv vnstat_php_frontend-1.5.1 bandwidth
cd bandwidth
sed -i "s/\$iface_list = array('eth0', 'sixxs');/\$iface_list = array('eth0');/g" config.php
sed -i "s/\$language = 'nl';/\$language = 'en';/g" config.php
sed -i 's/Internal/Internet/g' config.php
sed -i '/SixXS IPv6/d' config.php
sed -i "s/\$locale = 'en_US.UTF-8';/\$locale = 'en_US.UTF+8';/g" config.php

if [ -e '/var/lib/vnstat/eth0' ]; then
	vnstat -u -i eth0
else
sed -i "s/eth0/ens3/g" /home/vps/public_html/bandwidth/config.php
vnstat -u -i ens3
fi

ok "➡ service vnstat restart "
service vnstat restart -q > /dev/null 2>&1

# Iptables
ok "➡ apt-get install iptables "
apt-get install -qy iptables > /dev/null 2>&1
if [ -e '/var/lib/vnstat/eth0' ]; then
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
else
iptables -t nat -I POSTROUTING -s 10.8.0.0/24 -o ens3 -j MASQUERADE
fi
iptables -I FORWARD -s 10.8.0.0/24 -j ACCEPT
iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
 iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to-source $SERVER_IP

iptables-save > /etc/iptables.conf

cat > /etc/network/if-up.d/iptables <<EOF
#!/bin/sh
iptables-restore < /etc/iptables.conf
EOF

chmod +x /etc/network/if-up.d/iptables

# Enable net.ipv4.ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward

# setting time
ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

 
# download script
cd /usr/bin
wget -q -O g "https://raw.githubusercontent.com/phutthasit2530/openautog/master/menu"
wget -q -O speedtest "https://raw.githubusercontent.com/phutthasit2530/openautog/master/speedtest"
wget -q -O b-user "https://raw.githubusercontent.com/phutthasit2530/openautog/master/b-user"


echo "30 3 * * * root /sbin/reboot" > /etc/cron.d/reboot
chmod +x speedtest
chmod +x g
chmod +x b-user
service cron restart -q > /dev/null 2>&1


# XML Parser
ok "➡ apt-get install XML Parser "
cd
apt-get -y --force-yes -f install libxml-parser-perl


clear
clear
echo ""
echo ""
echo -e "\033[1;31m  =============== OS-32 & 64-bit =================    "
echo -e "\033[1;31m  #                                              #    "
echo -e "\033[1;31m  #        AUTOSCRIPT ─━═हຫມາສີ້ແມ່ມືງह═━─          #    "
echo -e "\033[1;31m  #      -----------About Us------------         #    "
echo -e "\033[1;31m  #       OS  Debian 8-9  OS  Ubuntu 14-16       #    "
echo -e "\033[1;31m  #               { VPN / SSH }                  #    "
echo -e "\033[1;31m  #         BY : ─━═हຫມາສີ້ແມ່ມືງह═━─               #    "
echo -e "\033[1;31m  =============== OS-32 & 64-bit =================    "
echo -e "\033[1;36m  ไอพีเซิฟ:$IP "
echo -e "\033[0m       "
echo ""
echo ""
echo -e "\e[32m    =====================================================  "
echo -e "\e[32m    #                                                   #    "
echo -e "\e[32m    #             SYSTEM MANAGER VPN SSH                #    "
echo -e "\e[32m    #                                                   #    "
echo -e "\e[32m    #    IP             :   $IP                         #    "
echo -e "\e[32m    #    Dropbear       :   22, 443                     #    "
echo -e "\e[32m    #    SSL            :   444                         #    "
echo -e "\e[32m    #    Squid3         :   3128, 8080                  #    "
echo -e "\e[32m    #    OpenVPN        :   TCP 1194 [Edit] TCP 443     #    "
echo -e "\e[32m    #    Nginx          :   85                          #    "
echo -e "\e[32m    #                                                   #    "
echo -e "\e[32m    #  [√] INSTALL SUCCESS ^^                           #    " 
echo -e "\e[32m    #  [√] การติดตั้งเสร็จสมบรูณ์ .....                       #    "
echo -e "\e[32m    #  [√] OK .....                                     #    "
echo -e "\e[32m    #                                                   #    "
echo -e "\e[32m    #  ติดตั้งสำเร็จ... กรุณาพิมพ์คำสั่ง   g เพื่อไปยังขั้นตอนถัดไป  #    "
echo -e "\e[32m    #                                                   #    "
echo -e "\e[32m    ================================= ====================  "
echo -e "\e[0m      "
read -n1 -r -p "                Press Enter To Show Commands                         "
g

cd
rm -f install
rm -f /root/install_openvpn
