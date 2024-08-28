#!/bin/bash

# Set color codes
NC='\e[0m'
GB='\e[32;1m'
YB='\e[33;1m'

# Read JSON input from stdin
read INPUT_DATA

# Parse JSON input using jq
User=$(echo "$INPUT_DATA" | jq -r '.username')
Days=$(echo "$INPUT_DATA" | jq -r '.days')

# Check if the username exists
if id -u "$User" >/dev/null 2>&1; then

    # Calculate new expiration date
    Today=$(date +%s)
    Days_Detailed=$((Days * 86400))
    Expire_On=$(($Today + $Days_Detailed))
    Expiration=$(date -u --date="1970-01-01 $Expire_On sec GMT" +%Y/%m/%d)
    Expiration_Display=$(date -u --date="1970-01-01 $Expire_On sec GMT" '+%d %b %Y')

    # Unlock user and extend expiration date
    passwd -u "$User"
    usermod -e "$Expiration" "$User"
    
    # Respond with success JSON
    OUTPUT=$(jq -n \
      --arg username "$User" \
      --arg days "$Days" \
      --arg expiration "$Expiration_Display" \
      '{message: "User renewed successfully", username: $username, days_added: $days, expires_on: $expiration}')

else
    # Respond with error JSON
    OUTPUT=$(jq -n \
      --arg error "Username does not exist" \
      '{error: $error}')
fi

#Detail Bot Notif Telegram
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$OUTPUT" $URL >/dev/null 2>&1

# Print the output JSON
clear
echo "$OUTPUT" | jq .