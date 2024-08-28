#!/bin/bash
#
#  |════════════════════════════════════════════════════════════════════════════════════=======|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |════════════════════════════════════════════════════════════════════════════════════=======|
#
# Read POST data
read POST_DATA

# Parse POST data using jq
expired=$(echo $POST_DATA | jq -r '.expired')
user=trial`</dev/urandom tr -dc 0-9 | head -c3`

# Get domain
domain=$(cat /etc/xray/domain)

# Check if user already exists
client_exists=$(grep -w $user /etc/xray/config.json | wc -l)
if [[ ${client_exists} == '1' ]]; then
  echo -e "{\"error\": \"A client with the specified name was already created, please choose another name.\"}"
  exit 1
fi

# Set expiration date
exp=$(date -d "$expired days" +"%y-%m-%d")

# Set UUID
uuid=${user}

# Add user to config
sed -i '/#trojan$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json

# Create Trojan links
link1="trojan://${uuid}@${domain}:443?mode=gun&security=tls&authority=${domain}&type=grpc&serviceName=trojan-grpc&sni=${domain}#${user}"
link2="trojan://${uuid}@${domain}:443?path=%2ftrojanws&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
link3="trojan://${uuid}@${domain}:443?path=/dinda&security=tls&host=${domain}&type=httpupgrade&sni=${domain}#${user}"
link4="trojan://${uuid}@${domain}:443?path=/trojan-split&security=tls&host=${domain}&type=splithttp&sni=${domain}#${user}"
link5="trojan://${uuid}@${domain}:80?path=trojan-split&security=none&host=${domain}&type=splithttp#${user}"

# Restart Xray service
systemctl restart xray

# Generate output JSON
OUTPUT=$(jq -n \
  --arg user "$user" \
  --arg domain "$domain" \
  --arg uuid "$uuid" \
  --arg exp "$exp" \
  --arg link1 "$link1" \
  --arg link2 "$link2" \
  --arg link3 "$link3" \
  --arg link4 "$link4" \
  --arg link5 "$link5" \
  --arg expired "$expired" \
  '{
    remarks: $user,
    hostname: $domain,
    wildcard: ("bug.com." + $domain),
    expired: "$expired Minutes",
    password: $uuid,
    ports: {
      ws_https: "443",
      ws_http: "80"
    },
    paths: {
      ws: "/trojan | /trojanws",
      http: "/dinda | /dindaputri",
      split: "/trojan-split"
    },
    serviceName: "trojan-grpc",
    links: {
      websocket: $link2,
      http_tls: $link3,
      split_tls: $link4,
      split_http: $link5,
      grpc: $link1
    }
  }')

# Send notification to Telegram
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$OUTPUT" $URL >/dev/null 2>&1
echo "sed -i '/^### $user $exp/,/^},{/d' /etc/xray/config.json && systemctl restart xray" | at now + $expired minutes

# Print the output JSON
clear
echo "$OUTPUT" | jq .