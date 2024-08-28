#!/bin/bash

# Read POST data
read POST_DATA

# Parse POST data using jq
username=$(echo $POST_DATA | jq -r '.username')
password=$(echo $POST_DATA | jq -r '.password')
expired=$(echo $POST_DATA | jq -r '.expired')

# Get domain
domain=$(cat /etc/xray/domain)

# Create the user and set expiration
noobzvpns --add-user "$username" "$pass"
noobzvpns --expired-user "$username" "$masaaktif"
exp=`date -d "$expired days" +"%Y-%m-%d"`
echo "### ${username} ${expi}" >>/etc/noobzvpns/.noob
wsx="GET / HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf]"
systemctl restart noobzvpns
clear
# Generate the output JSON
OUTPUT=$(jq -n \
  --arg username "$username" \
  --arg password "$password" \
  --arg host_ip "$domain" \
  --arg expi "$exp" \
  --arg ws "$wsx" \
  "{
    username: \$username,
    password: \$password,
    host_ip: \$host_ip,
    tcp_std: \"8080\",
    tcp_ssl: \"8443\",
    payloads: {
      ws: \$ws
    },
    expired: \$expi
  }")

# Send notification to Telegram (optional)
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$OUTPUT" $URL >/dev/null 2>&1

# Print the output JSON
clear
echo "$OUTPUT" | jq .
