#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
#IP=$(wget -qO- ipinfo.io/ip);
IP=$(curl -s ifconfig.me);
date=$(date +"%Y-%m-%d")
clear
email=$(cat /home/email)
if [[ "$email" = "" ]]; then
  echo -e "\e[0;37m Enter Your Email To Receive Backup"
  read -rp " Email: " -e email
  cat <<EOF>>/home/email
$email
EOF
fi
domain=$(cat /etc/xray/domain)
clear
mkdir -p /root/backup
sleep 1
echo Start Backup
rm -rf /root/backup
rm -rf /root/*
mkdir /root/backup
cp /etc/passwd /root/backup/
cp /etc/group /root/backup/
cp /etc/shadow /root/backup/
cp /etc/gshadow /root/backup/
cp -r /etc/xray /root/backup/xray
cp -r /etc/funny /root/backup/funny
cp -r /etc/noobzvpns /root/backup/noobzvpns
cd /root
zip -r Backup-$date.zip backup > /dev/null 2>&1
rclone copy /root/Backup-$date.zip dr:backup/
url=$(rclone link dr:backup/Backup-$date.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"
echo -e "
Detail Backup
==================================
ID VPS        : $id
IP VPS        : $IP
Domain.       : $domain
Link Backup   : $link
Date Backup   : $date
==================================
" | mail -s "VPS Backup Data | $date" $email
clear
rm -fr www*
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL1="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEKS&parse_mode=html" $URL1 >/dev/null
URL2="https://api.telegram.org/bot$KEY/sendDocument"
cpt="$(date) / $domain"
CAPTION="${cpt}"
curl -s --max-time $TIME -F chat_id=$CHATID -F document=@Backup-$date.zip -F caption="$CAPTION" $URL2 >/dev/null
clear
echo -e "
Detail Backup
==================================
IP VPS        : $IP
Link Backup   : $link
Date Backup   : $date
==================================
"
rm -rf /root/backup
rm -r /root/Backup-$date.zip
echo -e "\e[0;37m Done!"
echo ""
echo -e "\e[0;37m Please Check Your Email Now!"
echo ""
read -sp " Press ENTER to go back"
echo ""
menu
