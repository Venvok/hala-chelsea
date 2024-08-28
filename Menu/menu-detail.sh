#!/bin/bash
clear

gen() {
	echo -e "Updates"
	sleep 2
        for i in {1..5}; do
    	echo -ne ".\r"
    	sleep 0.5
    	echo -ne "..\r"
    	sleep 0.5
    	echo -ne "...\r"
    	sleep 0.5
    	echo -ne "....\r"
    	sleep 0.5
    	echo -ne ".....\r"
    	sleep 0.5
    	echo -ne "     \r"
    	sleep 0.5
	done
	echo -e "Done!"
	curl https://ifconfig.me/all
	sleep 1
	clear
	curl ipinfo.io/org > /root/.isp
	curl ipinfo.io/city > /root/.city
	curl ipinfo.io/region > /root/.region
	clear
	echo -e "\nSuccess Updates Information"
}

cek() {
response=$(curl -s https://1.1.1.1/cdn-cgi/trace)
warp_status=$(echo "$response" | grep -oP '(?<=warp=)[^ ]+')
if [ "$warp_status" = "on" ]; then
    service="on"
else
    service="off"
fi
clear
echo -e "

<= Detail your Server =>
========================
Autoscript by FN Project

#Port
- OpenSSH        : 22, 3303, 443, 53
- Dropbear       : 111, 109, 69, 143
- Stunnel        : 443, 777
- Slowdns        : 5300
- WS HTTPS       : 443
- WS HTTP        : 80, 2082, 8880
- OpenVPN        : 1194, 2200, 443, 80, 2095
- Noobz STD      : 8080
- Noobz SSL      : 8443
- SSLH           : 443
- TINC           : 655, 443
- XMPP           : 5222, 443
- ADB            : 5037, 443
- CHISEL         : 8000, 9443
- API            : 443, 80, 9000, 1278

#Protokol
- SSH, CHISEL, OVPN, SLOWDNS, STUNNEL, DROPBEAR
- NOOBZVPNS TCP STD, TCP SSL
- V2RAY/XRAY VMESS, VLESS, TROJAN, SOCKS5, SHADOWSOCKS
- SSLH, TINC, ZMPP, ADB, API, NGINX, HAPROXY

#Detail
- Domain = $(cat /etc/xray/domain)
- Warp   = ${service}
- ISP    = $(cat /root/.isp)
- Region = $(cat /root/.region)
- City   = $(cat /root/.city)
========================
"
}

status() {
clear
echo -e "


Coming Soon on Versi 1.10?
==========================
"
}

tamp() {
echo -e "
<=  Menu Detail  =>
===================

1. Update Information
2. Cek Detail Information
3. Cek Status Service Server
===================
"
read -p "Input Option: " opws
case $opws in
1) clear ; gen ;;
2) clear ; cek ;;
3) clear ; status ;;
*) clear ; tamp ;;
esac
}

tamp
