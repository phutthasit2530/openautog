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

#install squid3

apt-get -y install squid;
cp /etc/squid/squid.conf /etc/squid3/squid.conf.bak
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/jiraphaty/auto-script-vpn/master/squid.conf"
sed -i $MYIP2 /etc/squid/squid.conf;
systemctl restart squid

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



# download script
cd /usr/bin
wget -O member "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/member.sh"
wget -O menu "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/usernew.sh"
wget -O speedtest "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/speedtest_cli.py"
wget -O userd "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/deluser.sh"
wget -O trial "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/trial.sh"
wget -O mutiply "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/mutiply.sh"
wget -O proxy "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/proxy.sh"
wget -O 443 "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/443.sh"
wget -O update "https://raw.githubusercontent.com/MyGatherBk/pirakit/master/update.sh"
echo "0 0 * * * root /usr/bin/reboot" > /etc/cron.d/reboot
#echo "* * * * * service dropbear restart" > /etc/cron.d/dropbear
chmod +x member
chmod +x menu
chmod +x usernew
chmod +x speedtest
chmod +x userd
chmod +x trial
chmod +x mutiply
chmod +x proxr
chmod +x 443
chmod +x update
clear


# info
clear
echo "OpenSSH  : 22 " 
echo "Proxy  : Insall Proxy In MENU " 
echo "OpenVPN  : TCP 1194 (client config : http://$MYIP:85/root/client.ovpn)" 
echo "nginx    : 85"  
echo "Script menu  : menu Script " 
cd
printf 'nคุณจำเป็นต้องรีสตาร์ทระบบหนึ่งรอบ (y/n):'
read a
if [ $a == 'y' ]
then
reboot
else
exit
fi
