#!/bin/bash

# Set color codes (Not used in the script, but kept for potential future use)
NC='\e[0m'
GB='\e[32;1m'
YB='\e[33;1m'

# Read DELETE data from stdin
read DELETE_DATA

# Parse DELETE data using jq
user=$(echo "$DELETE_DATA" | jq -r '.username')

# Check if there are any clients
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
if [[ "$NUMBER_OF_CLIENTS" == '0' ]]; then
    echo -e "{\"error\": \"You have no existing clients!\"}"
    exit 1
fi

# Check if username is provided
if [ -z "$user" ]; then
    echo -e "{\"error\": \"Username is required!\"}"
    exit 1
fi

# Find expiration date of the user
exp=$(grep -wE "^### $user" "/etc/xray/config.json" | awk '{print $3}' | sort | uniq)

# If user not found, return error
if [ -z "$exp" ]; then
    echo -e "{\"error\": \"User not found!\"}"
    exit 1
fi

# Remove user from config.json
sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json

# Restart the Xray service
systemctl restart xray > /dev/null 2>&1

# Generate JSON response
OUTPUT=$(jq -n \
  --arg user "$user" \
  --arg exp "$exp" \
  '{message: "V2ray account successfully deleted", user: $user, expired: $exp}')

# Send notification to Telegram (optional)
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$OUTPUT" $URL >/dev/null 2>&1

# Print the output JSON
clear
echo "$OUTPUT" | jq .