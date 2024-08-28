#!/bin/bash

# Cek apakah `curl` terpasang, lalu tambahkan `1.1.1.1` ke `/etc/resolv.conf` jika belum ada
[[ -e $(which curl) ]] && grep -q "1.1.1.1" /etc/resolv.conf || { 
    echo "nameserver 1.1.1.1" | cat - /etc/resolv.conf > /etc/resolv.conf.tmp && mv /etc/resolv.conf.tmp /etc/resolv.conf
}

# Informasi skrip dan tim pengembang
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|

# Inisialisasi variabel
date=$(date)
domain=$(cat /etc/xray/domain)
cpt="$date / $domain"
MYIP=$(curl -s ifconfig.me)

# Proses Backup
clear
echo "Mohon Menunggu, Proses Backup sedang berlangsung!!"
rm -rf /root/backup /root/*
mkdir -p /root/backup

# Salin file yang akan di-backup
cp /etc/passwd /etc/group /etc/shadow /etc/gshadow /root/backup/
cp -r /etc/xray /etc/funny /etc/noobzvpns /root/backup/

# Membuat file ZIP dari backup
cd /root
zip -r backup.zip backup > /dev/null 2>&1

# Upload file ZIP ke file.io dan ambil link
random_number=$(gpg --gen-random 2 90 | tr -dc A-Za-z0-9 | sed 's/\(..\)/\1:/g; s/.$//')
file_path="/root/backup.zip"
api_url="https://file.io"
expiry_duration=$((14 * 24 * 60 * 60))
response=$(curl -s -F "file=@$file_path" -F "expiry=$expiry_duration" $api_url)
upload_link=$(echo $response | jq -r .link)
id_link=$(echo $response | jq -r .key)

# Persiapkan pesan Telegram
TEKS="
[ Information Your Backup Data ]
================================

Your ID    : $id_link
Your IP    : $MYIP
Link Backup: $upload_link
================================
Your File Backup AutoDelete After 7 Days
"

# Cek dan buat file backup.log jika tidak ada
if [ ! -f /etc/funny/backup.log ]; then
    touch /etc/funny/backup.log
    echo "File /etc/funny/backup.log telah dibuat."
else
    echo "File /etc/funny/backup.log sudah ada, melanjutkan perintah selanjutnya."
fi

# Menyimpan Log Backup
echo "$TEKS" >> /etc/funny/backup.log
clear

# Kirim pesan ke Telegram
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL1="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEKS&parse_mode=html" $URL1 >/dev/null

# Kirim file backup ke Telegram
URL2="https://api.telegram.org/bot$KEY/sendDocument"
CAPTION="$cpt"
curl -s --max-time $TIME -F chat_id=$CHATID -F document=@backup.zip -F caption="$CAPTION" $URL2 >/dev/null

# Bersihkan file backup setelah selesai
rm -fr /root/backup*

# Output informasi backup ke layar
clear
echo "$TEKS"
echo "Please Save your Link Backup"