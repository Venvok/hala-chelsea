#!/bin/bash

# Ensure curl is available and update resolv.conf if needed
[[ -e $(which curl) ]] && if [[ -z $(cat /etc/resolv.conf | grep "1.1.1.1") ]]; then
    cat <(echo "nameserver 1.1.1.1") /etc/resolv.conf > /etc/resolv.conf.tmp
    mv /etc/resolv.conf.tmp /etc/resolv.conf
fi

# Variables
date=$(date)
domain=$(cat /etc/xray/domain)
cpt="$date / $domain"
backup_dir="/root/backup"
backup_file="/root/backup.zip"
api_url="https://file.io"
expiry_duration=$((14 * 24 * 60 * 60))
output=""

# Prepare backup
rm -rf "$backup_dir"
mkdir -p "$backup_dir"
cp /etc/passwd "$backup_dir/"
cp /etc/group "$backup_dir/"
cp /etc/shadow "$backup_dir/"
cp /etc/gshadow "$backup_dir/"
cp -r /etc/xray "$backup_dir/xray"
cp -r /etc/funny "$backup_dir/funny"
cp -r /var/lib/marzban "$backup_dir/marzban"

# Compress backup
cd /root || exit
zip -r "$backup_file" backup > /dev/null 2>&1

# Generate random ID and upload the backup
random_number=$(gpg --gen-random 2 90 | tr -dc A-Za-z0-9 | sed 's/\(..\)/\1:/g; s/.$//')
response=$(curl -s -F "file=@$backup_file" -F "expiry=$expiry_duration" $api_url)
upload_link=$(echo "$response" | jq -r .link)

# Collect IP information
MYIP=$(curl -s ifconfig.me)

# Prepare message text
TEKS="
[ Information Your Backup Data ]
================================

Your ID    : $random_number
Your IP    : $MYIP
Link Backup: $upload_link
================================
Your File Backup AutoDelete After 7 Days
"

# Send notification to Telegram
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL1="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$TEKS" $URL1 >/dev/null 2>&1
URL2="https://api.telegram.org/bot$KEY/sendDocument"
CAPTION="$cpt"
curl -s --max-time $TIME -F chat_id=$CHATID -F document=@backup.zip -F caption="$CAPTION" $URL2 >/dev/null 2>&1

# Clean up
rm -fr "$backup_dir" "$backup_file"
mlbb="Your File Backup AutoDelete After 7 Days"

# Output JSON response
output=$(jq -n \
  --arg id "$random_number" \
  --arg ip "$MYIP" \
  --arg link "$upload_link" \
  --arg message "$mlbb" \
  '{
    id: $id,
    ip: $ip,
    link: $link,
    "note or message": $message
  }')

clear
echo "$output" | jq .