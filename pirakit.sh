#!/bin/bash
#script by jiraphat yuenying for debian9

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

#install openvpn

apt-get purge openvpn easy-rsa -y;
apt-get purge squid -y;
apt-get purge ufw -y;
apt-get update
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

apt-get update
apt-get install bc -y
apt-get -y install openvpn easy-rsa;
apt-get -y install python;

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
systemctl restart openvpn

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

# install nginx
echo ""
echo -e " { install nginx }  "
echo ""
	cd
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
	echo "<pre>by MyGatherBK | MyGatherBK</pre>" > /home/vps/public_html/index.html
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

	if [[ "$VERSION_ID" = 'VERSION_ID="7"' || "$VERSION_ID" = 'VERSION_ID="8"' || "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
		if [[ -e /etc/squid3/squid.conf ]]; then
			apt-get -y remove --purge squid3
		fi
echo ""
echo -e "\033[0;32m { Insatll PROXY }  "
echo ""
		apt-get -y install squid3
		cat > /etc/squid3/squid.conf <<END
http_port $PROXY
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
acl SSH dst xxxxxxxxx-xxxxxxxxx/255.255.255.255
http_access allow SSH
http_access allow localnet
http_access allow localhost
http_access deny all
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
END
		IP2="s/xxxxxxxxx/$IP/g";
		sed -i $IP2 /etc/squid3/squid.conf;
		if [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
			service squid3 restart
			/etc/init.d/openvpn restart
			/etc/init.d/nginx restart
		else
			/etc/init.d/squid3 restart
			/etc/init.d/openvpn restart
			/etc/init.d/nginx restart
		fi

	elif [[ "$VERSION_ID" = 'VERSION_ID="9"' || "$VERSION_ID" = 'VERSION_ID="16.04"' || "$VERSION_ID" = 'VERSION_ID="18.04"' ]]; then
		if [[ -e /etc/squid/squid.conf ]]; then
			apt-get -y remove --purge squid
		fi
echo ""
echo -e "\033[0;32m { Insatll PROXY }  "
echo ""
		apt-get -y install squid
		cat > /etc/squid/squid.conf <<END
http_port $PROXY
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
acl SSH dst xxxxxxxxx-xxxxxxxxx/255.255.255.255
http_access allow SSH
http_access allow localnet
http_access allow localhost
http_access deny all
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
END
		IP2="s/xxxxxxxxx/$IP/g";
		sed -i $IP2 /etc/squid/squid.conf;
		/etc/init.d/squid restart
		/etc/init.d/openvpn restart
		/etc/init.d/nginx restart
	fi

fi



# download script
        wget -O /usr/local/bin/menu "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/menu"
	chmod +x /usr/local/bin/menu
	wget -O /usr/local/bin/Auto-Delete-Client "https://raw.githubusercontent.com/MyGatherBk/PURE/master/Auto-Delete-Client"
	chmod +x /usr/local/bin/Auto-Delete-Client 
	apt-get -y install vnstat


# info
clear
echo "Autoscript Include:" | tee log-install.txt
echo "===========================================" | tee -a log-install.txt

echo "OpenSSH  : 22 " 
echo "Proxy  : $PROXY " 
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:85/root/client.ovpn)" 
echo "nginx    : 85"  
cd
printf 'nคุณจำเป็นต้องรีสตาร์ทระบบหนึ่งรอบ (y/n):'
read a
if [ $a == 'y' ]
then
reboot
else
exit
fi
