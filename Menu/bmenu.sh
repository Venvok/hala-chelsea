#!/bin/bash
#
#  |==========================================================|
#  • Autoscript AIO Lite Menu By Rerechan02
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @xlordeuyy
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ]
#  |==========================================================|
#

# [ New Copyright ]
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 10 Mei Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
rest() {
clear
echo "This Feature Can Only Be Used According To Vps Data With This Autoscript"
echo "Please input link to your vps data backup file."
read -rp "Link File: " -e url
cd /root
wget -O backup.zip "$url"
unzip backup.zip
rm -f backup.zip
sleep 1
echo "Tengah Melakukan Backup Data"
cd /root/backup
cp passwd /etc/
cp group /etc/
cp shadow /etc/
cp gshadow /etc/
cp -r xray /etc/
cp -r funny /etc/
cp -r noobzvpns /etc/
cp -r marzban /var/lib/
clear
cd
rm -rf /root/backup
rm -f backup.zip
systemctl daemon-reload
systemctl restart ssh
systemctl restart sshd
systemctl restart xray
systemctl restart noobzvpns
systemctl restart server
systemctl restart quota
clear
echo "Telah Berjaya Melakukan Backup"
}

resid() {
resp() {
cd /root
wget -O backup.zip "$url"
unzip backup.zip
rm -f backup.zip
sleep 1
echo "Tengah Melakukan Backup Data"
cd /root/backup
cp passwd /etc/
cp group /etc/
cp shadow /etc/
cp gshadow /etc/
cp -r xray /etc/
cp -r funny /etc/
cp -r noobzvpns /etc/
cp -r marzban /var/lib/
clear
cd
rm -rf /root/backup
rm -f backup.zip
systemctl daemon-reload
systemctl restart ssh
systemctl restart sshd
systemctl restart xray
systemctl restart noobzvpns
systemctl restart server
systemctl restart quota
clear
echo "Telah Berjaya Melakukan Backup"
}
clear
echo "Select Database Source"
echo "======================"
echo "1. file.io"
echo "2. Google Drive"
echo "======================"
read -rp "Input Option: " choice
read -rp "ID Database: " -e id
case $choice in
    1)
        url="https://file.io/${id}"
	resp
        ;;
    2)
        url="https://drive.google.com/u/4/uc?id=${id}&export=download"
	resp
        ;;
    *)
        echo "Pilihan tidak valid. Harap masukkan 1 atau 2."
        exit 1
        ;;
esac
}

resid2() {
clear
echo "This Feature Can Only Be Used According To Vps Data With This Autoscript"
echo "Please input ID to your vps data backup file."
read -rp "ID Database: " -e id
url="https://file.io/${id}"
cd /root
wget -O backup.zip "$url"
unzip backup.zip
rm -f backup.zip
sleep 1
echo "Tengah Melakukan Backup Data"
cd /root/backup
cp passwd /etc/
cp group /etc/
cp shadow /etc/
cp gshadow /etc/
cp -r xray /etc/
cp -r funny /etc/
cp -r noobzvpns /etc/
cp -r marzban /var/lib/
clear
cd
rm -rf /root/backup
rm -f backup.zip
systemctl daemon-reload
systemctl restart ssh
systemctl restart sshd
systemctl restart xray
systemctl restart noobzvpns
systemctl restart server
systemctl restart quota
clear
echo "Telah Berjaya Melakukan Backup"
}

restf() {
cd /root
mv /root/*.zip /root/backup.zip
file="backup.zip"
if [ -f "$file" ]; then
echo "$file ditemukan, melanjutkan proses..."
sleep 2
clear
unzip backup.zip
rm -f backup.zip
sleep 1
echo "Tengah Melakukan Backup Data"
cd /root/backup
cp passwd /etc/
cp group /etc/
cp shadow /etc/
cp gshadow /etc/
cp -r xray /etc/
cp -r funny /etc/
cp -r noobzvpns /etc/
cp -r marzban /var/lib/
clear
cd
rm -rf /root/backup
rm -f backup.zip
systemctl daemon-reload
systemctl restart ssh
systemctl restart sshd
systemctl restart xray
systemctl restart noobzvpns
systemctl restart server
systemctl restart quota
clear
echo "Telah Berjaya Melakukan Backup"
else
    echo "Error: File $file Not Found"
fi
}

clear

bmenu() {
clear
echo "
============================
Menu Backup Data VPN in VpS
============================

1. Backup Your Data VPN
2. Backup Via Google Drive
3. Restore With Link Backup
4. Restore With ID Database
5. Restore With SFTP / Termius
6. Bot Notification Setup on Server
==============================
Press CTRL + C / X to Exit Menu
"
read -p "Input Valid Number Option: " mla
case $mla in
1) clear ; backup ;;
2) clear ; backup-gd ;;
3) clear ; rest ;;
4) clear ; resid ;;
5) clear ; restf ;;
6) botmenu ;;
x) exit ;;
*) echo " Please Input Valid Number " ; bmenu ;;
esac
}

bmenu
