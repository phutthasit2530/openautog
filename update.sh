rm -f /usr/bin
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
