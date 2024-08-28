#!/bin/bash

NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'

# Read POST data
read POST_DATA

# Parse POST data using jq
user=$(echo $POST_DATA | jq -r '.username')
pass=$(echo $POST_DATA | jq -r '.password')
expired=$(echo $POST_DATA | jq -r '.expired')

# Get domain
domain=$(cat /etc/xray/domain)

# Check if user already exists
CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
if [[ ${CLIENT_EXISTS} == '1' ]]; then
  echo -e "{\"error\": \"A client with the specified name was already created, please choose another name.\"}"
  exit 1
fi

# Check if password already exists
CLIENT_EXISTS=$(grep -w $pass /etc/xray/config.json | wc -l)
if [[ ${CLIENT_EXISTS} == '1' ]]; then
  echo -e "{\"error\": \"A client with the specified password was already created, please choose another password.\"}"
  exit 1
fi

# Set expiration date
exp=$(date -d "$expired days" +"%Y-%m-%d")

# Add user to config
sed -i '/#socks$/a\### '"$user $exp"'\
},{"user": "'""$user""'","pass": "'""$pass""'","email": "'""$user""'"' /etc/xray/config.json

# Create SOCKS links
echo -n "$user:$pass" | base64 > /tmp/log
socks_base64=$(cat /tmp/log)
sockslink1="socks://$socks_base64@$domain:443?path=/socks5&security=tls&host=$domain&type=ws&sni=$domain#$user"
sockslink2="socks://$socks_base64@$domain:80?path=/socks5&security=none&host=$domain&type=ws#$user"
rm -rf /tmp/log

# Restart Xray service
systemctl restart xray

# Generate output JSON
OUTPUT=$(jq -n \
  --arg username "$user" \
  --arg password "$pass" \
  --arg domain "$domain" \
  --arg sockslink1 "$sockslink1" \
  --arg sockslink2 "$sockslink2" \
  --arg exp "$exp" \
  '{
    username: $username,
    password: $password,
    domain: $domain,
    ports: {
      tls: "443",
      ntls: "80"
    },
    network: "Websocket",
    path: "/socks5",
    links: {
      tls: $sockslink1,
      ntls: $sockslink2
    },
    expired_on: $exp
  }')


# Send notification to Telegram (optional)
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$OUTPUT" $URL >/dev/null 2>&1

# Print the output JSON
clear
echo "$OUTPUT" | jq .