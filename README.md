# pirakit
-
- OpenSSH, port : 22, 80
- Dropbear, port : 143, 443
- Squid3, port : 8080, 3128 (limit to IP SSH)
- Badvpn   : badvpn-udpgw port 7300
- Webmin   : http://IPVPS:10000/
- Nginx    : 81
- OpenVPN TCP 1194
- Script menu : g
-

Auto-Install Script :-

apt-get install wget && wget https://raw.githubusercontent.com/MyGatherBk/pirakit/master/pirakit.sh && ./pirakit.sh
