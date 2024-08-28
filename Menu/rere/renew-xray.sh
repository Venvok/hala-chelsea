#!/bin/bash

# Read JSON input from stdin
read INPUT_DATA

# Parse JSON input using jq
user=$(echo "$INPUT_DATA" | jq -r '.username')
masaaktif=$(echo "$INPUT_DATA" | jq -r '.days')

# Set color codes
NC='\e[0m'
GB='\e[32;1m'
YB='\e[33;1m'

# Check if there are any existing clients
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
    echo -e "{\"error\": \"You have no existing clients!\"}"
    exit 1
fi

# Check if username is provided
if [ -z "$user" ]; then
    echo -e "{\"error\": \"Username is required!\"}"
    exit 1
fi

# Get current expiration date of the user
exp=$(grep -wE "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
if [ -z "$exp" ]; then
    echo -e "{\"error\": \"User not found!\"}"
    exit 1
fi

# Calculate the new expiration date
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=$(date -d "$exp3 days" +"%Y-%m-%d")

# Update the expiration date in the config file
sed -i "/### $user/c\### $user $exp4" /etc/xray/config.json
systemctl restart xray > /dev/null 2>&1

# Generate JSON response
OUTPUT=$(jq -n \
  --arg user "$user" \
  --arg exp4 "$exp4" \
  '{message: "V2ray account successfully extended", username: $user, expires_on: $exp4}')

#Detail Bot Notif Telegram
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$OUTPUT" $URL >/dev/null 2>&1

# Print the output JSON
clear
echo "$OUTPUT" | jq .