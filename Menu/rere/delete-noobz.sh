#!/bin/bash

# Set color codes (for potential future use)
NC='\e[0m'
GB='\e[32;1m'
YB='\e[33;1m'

# Read DELETE data from stdin
read DELETE_DATA

# Parse DELETE data using jq
user=$(echo "$DELETE_DATA" | jq -r '.username')

# Check if the username is provided
if [ -z "$user" ]; then
    echo -e "{\"error\": \"Username is required!\"}"
    exit 1
fi

# Remove user from the system using noobzvpns command
noobzvpns --remove-user "$user"

# Restart the Noobz VPN service
systemctl restart noobzvpns > /dev/null 2>&1

# Generate the JSON response
OUTPUT=$(jq -n \
  --arg user "$user" \
  '{message: "Noobz account successfully deleted", username: $user}')

# Send notification to Telegram (optional)
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time "$TIME" --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$OUTPUT" "$URL" >/dev/null 2>&1

# Print the output JSON
clear
echo "$OUTPUT" | jq .