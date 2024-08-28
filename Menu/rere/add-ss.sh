#!/bin/bash

# Read POST data
read POST_DATA

# Parse POST data using jq
user=$(echo $POST_DATA | jq -r '.username')
expired=$(echo $POST_DATA | jq -r '.expired')

# Get domain
domain=$(cat /etc/xray/domain)

# Check if user already exists
CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
if [[ ${CLIENT_EXISTS} == '1' ]]; then
  echo -e "{\"error\": \"A client with the specified name was already created, please choose another name.\"}"
  exit 1
fi

# Generate password and set cipher
cipher="aes-128-gcm"
pwss=$(echo $RANDOM | md5sum | head -c 6; echo;)

# Set expiration date
exp=$(date -d "$expired days" +"%Y-%m-%d")

# Add user to config
sed -i '/#ss$/a\### '"$user $exp"'\
},{"password": "'""$pwss""'","method": "'""$cipher""'","email": "'""$user""'"' /etc/xray/config.json

# Create ShadowSocks links
echo -n "$cipher:$pwss" | base64 -w 0 > /tmp/log
ss_base64=$(cat /tmp/log)
shadowsockslink1="ss://${ss_base64}@$domain:443?path=/ssws&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
shadowsockslink2="ss://${ss_base64}@$domain:80?path=/ssws&security=none&host=${domain}&type=ws#${user}"
rm -rf /tmp/log

# Restart Xray service
systemctl restart xray

# Generate output JSON
OUTPUT=$(jq -n \
  --arg username "$user" \
  --arg domain "$domain" \
  --arg password "$pwss" \
  --arg exp "$exp" \
  --arg cipher "$cipher" \
  --arg shadowsockslink1 "$shadowsockslink1" \
  --arg shadowsockslink2 "$shadowsockslink2" \
  '{
    username: $username,
    domain: $domain,
    password: $password,
    expired: $exp,
    ports: {
      tls: "443",
      ntls: "80"
    },
    cipher: $cipher,
    network: "Websocket, gRPC",
    path: "/ssws",
    alpn: "h2, http/1.1",
    links: {
      tls: $shadowsockslink1,
      ntls: $shadowsockslink2
    }
  }')

# Send notification to Telegram
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$OUTPUT" $URL >/dev/null 2>&1

# Print the output JSON
clear
echo "$OUTPUT" | jq .