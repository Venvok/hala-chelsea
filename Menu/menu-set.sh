#!/bin/bash
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
reres() {
clear
                sleep 1
                systemctl daemon-reload
                systemctl stop systemd-resolved
                /etc/init.d/ssh restart
                /etc/init.d/dropbear restart
                /etc/init.d/cron restart
                /etc/init.d/nginx restart
                /etc/init.d/hapoxy restart
                systemctl start systemd-resolved
                clear
                echo -e "[ \033[32mInfo\033[0m ] Restart Begin"
                sleep 1
                echo -e "[ \033[32mok\033[0m ] Restarting xray Service (via systemctl) "
                sleep 0.5
                systemctl restart xray
                systemctl restart xray.service
                echo -e "[ \033[32mok\033[0m ] Restarting badvpn Service (via systemctl) "
                sleep 0.5
                systemctl restart badvpn
                sleep 0.5
                echo -e "[ \033[32mok\033[0m ] Restarting websocket Service (via systemctl) "
                sleep 0.5
                systemctl restart proxy.service
                sleep 0.5
                echo -e "[ \033[32mInfo\033[0m ] ALL Service Restarted"
                echo ""
                echo -e "\e[33m===================================\033[0m"
                echo ""
}

bw() {
clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[40;1;37m      • BANDWITH MONITOR •         \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "" 
echo -e " [\e[36m•1\e[0m] Lihat Total Bandwith Tersisa"
echo -e " [\e[36m•2\e[0m] Tabel Penggunaan Setiap 5 Menit"
echo -e " [\e[36m•3\e[0m] Tabel Penggunaan Setiap Jam"
echo -e " [\e[36m•4\e[0m] Tabel Penggunaan Setiap Hari"
echo -e " [\e[36m•5\e[0m] Tabel Penggunaan Setiap Bulan"
echo -e " [\e[36m•6\e[0m] Tabel Penggunaan Setiap Tahun"
echo -e " [\e[36m•7\e[0m] Tabel Penggunaan Tertinggi"
echo -e " [\e[36m•8\e[0m] Statistik Penggunaan Setiap Jam"
echo -e " [\e[36m•9\e[0m] Lihat Penggunaan Aktif Saat Ini"
echo -e " [\e[36m10\e[0m] Lihat Trafik Penggunaan Aktif Saat Ini [5s]"
echo -e "" 
echo -e " [\e[31m•0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e " [\e[31m•x\e[0m] Keluar"
echo -e "" 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1)
clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[40;1;37m • TOTAL BANDWITH SERVER TERSISA • \e[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""

vnstat

echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;

2)
clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[40;1;37m • TOTAL BANDWITH SETIAP 5 MENIT • \e[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""

vnstat -5

echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;

3)
clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[40;1;37m   • TOTAL BANDWITH SETIAP JAM •   \e[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""

vnstat -h

echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;

4)
clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[40;1;37m  • TOTAL BANDWITH SETIAP HARI •   \e[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""

vnstat -d

echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;

5)
clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[40;1;37m  • TOTAL BANDWITH SETIAP BULAN •  \e[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""

vnstat -m

echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;

6)
clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[40;1;37m  • TOTAL BANDWITH SETIAP TAHUN •  \e[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""

vnstat -y

echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;

7)
clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[40;1;37m    • TOTAL BANDWITH TERTINGGI •   \e[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""

vnstat -t

echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;

8)
clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[40;1;37m • STATISTIK TERPAKAI SETIAP JAM • \e[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""

vnstat -hg

echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;

9)
clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[40;1;37m     • LIVE BANDWITH SAAT INI •    \e[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e   " Press [ Ctrl+C ] • To-Exit"
echo -e ""

vnstat -l

echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;

10)
clear 
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[40;1;37m• LIVE TRAFIK PENGGUNAAN BANDWITH •\e[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""

vnstat -tr

echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
bw
;;

0)
sleep 1
menu
;;
x)
exit
;;
*)
echo -e ""
echo -e "Anda salah tekan"
sleep 1
bw
;;
esac
}

    tz() {

    clear
echo -e "\e[32m════════════════════════════════════════" | lolcat
echo -e "\033[0;36m ═══[ \033[0m\e[1mCHANGE TIMEZONE\033[0;34m ]═══"
echo -e "\e[32m════════════════════════════════════════" | lolcat
echo -e " 1)  Malaysia (GMT +8:00)"
echo -e " 2)  Indonesia (GMT +7:00)"
echo -e " 3)  Singapore (GMT +8:00)"
echo -e " 4)  Brunei (GMT +8:00)"
echo -e " 5)  Thailand (GMT +7:00)"
echo -e " 6)  Philippines (GMT +8:00)"
echo -e " 7)  India (GMT +5:30)"
echo -e " 8)  Japan (GMT +9:00)"
echo -e " 9)  View Current Time Zone"
echo -e ""
echo -e "\e[1;32m══════════════════════════════════════════\e[m" | lolcat
echo -e " x)   MENU UTAMA"
echo -e "\e[1;32m══════════════════════════════════════════\e[m" | lolcat
echo -e ""
read -p " Select menu :  "  opt
echo -e ""
case $opt in
		1)
		clear
		timedatectl set-timezone Asia/Kuala_Lumpur
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo -e "\e[0m                                                   "
	    echo -e "\e[0m            Time Zone Set Asia Malaysia  "
		echo -e "\e[0m                                                   "
	    echo -e "\e[1;32m══════════════════════════════════════════\e[m"
        read -sp " Press ENTER to go back"
        echo ""
        change_timezone
		;;
		2)
		clear
		timedatectl set-timezone Asia/Jakarta
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo -e "\e[0m                                                   "
	    echo -e "\e[0m           Time Zone Set Asia Indonesia "
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo ""
        read -sp " Press ENTER to go back"
        echo ""
        change_timezone
		;;
		3)
		clear
		timedatectl set-timezone Asia/Singapore
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo -e "\e[0m                                                   "
	    echo -e "\e[0m           Time Zone Set Asia Singapore "
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo ""
        read -sp " Press ENTER to go back"
        echo ""
        change_timezone
		;;
		4)
		clear
		timedatectl set-timezone Asia/Brunei
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo -e "\e[0m                                                   "
	    echo -e "\e[0m            Time Zone Set Asia Brunei   "
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo ""
        read -sp " Press ENTER to go back"
        echo ""
        change_timezone
		;;
		5)
		clear
		timedatectl set-timezone Asia/Bangkok
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo -e "\e[0m                                                   "
	    echo -e "\e[0m            Time Zone Set Asia Thailand  "
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo ""
        read -sp " Press ENTER to go back"
        echo ""
        change_timezone
		;;
		6)
		clear
		timedatectl set-timezone Asia/Manila
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo -e "\e[0m                                                   "
		echo -e "\e[0;37m        Time Zone Set Asia Philippines"
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo ""
        read -sp " Press ENTER to go back"
        echo ""
        change_timezone
		;;
		7)
		clear
		timedatectl set-timezone Asia/Kolkata
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo -e "\e[0m                                                   "
	    echo -e "\e[0m            Time Zone Set Asia India"
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo ""
        read -sp " Press ENTER to go back"
        echo ""
        change_timezone
		;;
        8)
		clear
		timedatectl set-timezone Asia/Tokyo
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo -e "\e[0m                                                   "
	    echo -e "\e[0m            Time Zone Set Asia Japan"
		echo -e "\e[0m                                                   "
		echo -e "\e[1;32m══════════════════════════════════════════\e[m"
		echo ""
        read -sp " Press ENTER to go back"
        echo ""
        change_timezone
		;;
		9)
		clear
        echo ""
		timedatectl
	    echo ""
        read -sp " Press ENTER to go back"
        echo ""
        change_timezone
		;;
        x)
		clear
		menu
		;;
		*)
		change_timezone
		;;
	esac
	
	}

upker() {
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear
source /etc/os-release
OS=$ID


# Ubuntu Version
clear
echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
echo "Start Updating Kernel"
echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
sleep 0.5
if [[ $OS == 'ubuntu' ]]; then
wget https://raw.githubusercontent.com/pimlie/ubuntu-mainline-kernel.sh/master/ubuntu-mainline-kernel.sh
install ubuntu-mainline-kernel.sh /usr/local/bin/
rm -f ubuntu-mainline-kernel.sh
ubuntu-mainline-kernel.sh -c

# Checking Version
if [ $ver == $now ]; then
clear
echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
echo "Your Kernel Is The Latest Version"
echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
rm -f /usr/bin/ubuntu-mainline-kernel.sh
exit 0
else
printf "y" | ubuntu-mainline-kernel.sh -i
rm -f /usr/bin/ubuntu-mainline-kernel.sh
fi

# Debian Version
clear
echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
echo "Start Updating Kernel"
echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
elif [[ $OS == "debian" ]]; then
ver=(`apt-cache search linux-image | grep "^linux-image" | cut -d'-' -f 3-4 |tail -n1`)
now=$(uname -r | cut -d "-" -f 1-2)

# Checking Kernel
if [ $ver == $now ]; then
clear
echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
echo "Your Kernel Is The Latest Version"
echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
exit 0
else
apt install linux-image-$ver-amd64
fi

# Other OS Check
elif [[ $OS == "centos" ]]; then
    clear
    echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
    echo "Not Supported For Centos!"
    echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
    exit 1
elif [[ $OS == "fedora" ]]; then
    echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
    clear
    echo "Not Supported For Fedora"
    echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
    exit 1
else
    clear
    echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
    echo "Your OS Not Support"
    echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | lolcat
    exit 1
fi

# Done
echo "Your VPS Will Be Reboot In 5s"
sleep 5
reboot
}

webm() {
# ==========================================
clear
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[Installed]${Font_color_suffix}"
Error="${Red_font_prefix}[Not Installed]${Font_color_suffix}"
cek=$(netstat -ntlp | grep 10000 | awk '{print $7}' | cut -d'/' -f2)
function install () {
IP=$(curl ifconfig.me);
echo " Adding Repositori Webmin"
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
apt install gnupg gnupg1 gnupg2 -y
wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
echo " Start Install Webmin"
clear
sleep 0.5
apt update > /dev/null 2>&1
apt install webmin -y
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
/etc/init.d/webmin restart
rm -f /root/jcameron-key.asc
clear
echo ""
echo "======================="
echo "  Done Install Webmin  "
echo "======================="
echo "http://$(cat /etc/xray/domain):10000"
echo "======================="
echo "Script By Rere05"
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
function restart () {
echo " Restarting Webmin"
sleep 0.5
service webmin restart > /dev/null 2>&1
echo " Start Uninstall Webmin"
clear
echo ""
echo "======================="
echo "  Done Restart Webmin  "
echo "======================="
echo "Script By Rere05"
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
function uninstall () {
echo " Removing Repositori Webmin"
rm -f /etc/apt/sources.list.d/webmin.list
apt update > /dev/null 2>&1
echo " Start Uninstall Webmin"
clear
sleep 0.5
apt autoremove --purge webmin -y > /dev/null 2>&1
clear
echo ""
echo "========================="
echo "  Done Uninstall Webmin  "
echo "========================="
echo "Script By Rere05"
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
if [[ "$cek" = "perl" ]]; then
sts="${Info}"
else
sts="${Error}"
fi
clear
echo -e ""
echo -e "================================"
echo -e "   Webmin Menu $sts        "
echo -e "================================"
echo -e "1.Install Webmin"
echo -e "2.Restart Webmin"
echo -e "3.Uninstall Webmin"
echo -e "================================"
read -rp "Please Enter The Correct Number : " -e num
if [[ "$num" = "1" ]]; then
install
elif [[ "$num" = "2" ]]; then
restart
elif [[ "$num" = "3" ]]; then
uninstall
else
clear
echo " You Entered The Wrong Number"
menu
fi
}


menu1() {
clear
echo -e "
======================
   [ 菜单系统面板 ]
======================

01. Change Subdomain
02. Cek Usage Ram & Cpu
03. Cek Badwidth Trafik
04. Change Timezone Server
05. Update Kernel OS Server
06. Menu WebMin Web Master Cpanel
======================

07. Menu Domain / Subdomain Server
08. Menu Backup / Restore & Bot Notif
09. Restart All Service Fix Bug Service Off
10. Other Menu Detail data server
11. Report Bug to Admin
======================
Press CTRL + C to exit
"
read -p "Input Option: " opw
case $opw in
1) dm-menu ;;
2) htop ;;
3) clear ; bw ;;
4) clear ; tz ;;
5) upker ;;
6) webm ;;
7) dm-menu ;;
8) bmeu ;;
9) reres ;;
10) clear ; menu-detail ;;
11) clear ; report ;;
*) menu1 ;;
esac
}

menu4() {
menu1
}

menu2() {
menu4
}

menu3() {
menu2
}

menu14() {
menu3
}

rerechan02() {
menu14
}

rerechan02
