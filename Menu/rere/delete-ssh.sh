#!/bin/bash

# Set color codes (for potential future use)
RED='\e[31;1m'
GREEN='\e[32;1m'
NC='\e[0m'

# Read DELETE data from stdin
read DELETE_DATA

# Parse DELETE data using jq
username=$(echo "$DELETE_DATA" | jq -r '.username')

# If username is not provided, return an error
if [ -z "$username" ]; then
  echo -e "{\"error\": \"Username is required!\"}"
  exit 1
fi

# Check if the user exists
if getent passwd "$username" > /dev/null 2>&1; then
  # Record the user's home directory and other details before deletion
  home_dir=$(getent passwd "$username" | cut -d: -f6)
  groups=$(id -Gn "$username" | tr ' ' ',')
  
  # Delete the user and associated files
  userdel "$username" > /dev/null 2>&1
  rm -fr /etc/funny/limit/ssh/ip/"$username"
  rm -fr "$home_dir"
  
  # Generate a detailed JSON response
  OUTPUT=$(jq -n \
    --arg message "User $username was removed." \
    --arg home_dir "$home_dir" \
    --arg groups "$groups" \
    '{message: $message, user: {username: $username, home_dir: $home_dir, groups: $groups}}')

else
  # Return an error message if the user does not exist
  OUTPUT=$(jq -n \
    --arg error "Failure: User $username does not exist." \
    '{error: $error}')
fi

# Send notification to Telegram (optional)
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$OUTPUT" $URL >/dev/null 2>&1

# Print the output JSON
clear
echo "$OUTPUT" | jq .