#!/bin/bash

# Read POST data
read POST_DATA

# Parse POST data using jq
expired=$(echo $POST_DATA | jq -r '.expired')

# Generate trial account details
domain=$(cat /etc/xray/domain)
user=trial$(</dev/urandom tr -dc 0-9 | head -c3)
pass="1"
exp=$(date -d "$expired days" +"%Y-%m-%d")

# Update Xray config
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

# Generate JSON output
OUTPUT=$(jq -n \
  --arg username "$user" \
  --arg password "$pass" \
  --arg domain "$domain" \
  --arg sockslink1 "$sockslink1" \
  --arg sockslink2 "$sockslink2" \
  --arg expired "$expired" \
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
    expired_on: "$expired Minutes"
  }')

# Optionally send notification to Telegram
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$OUTPUT" $URL >/dev/null 2>&1

# Schedule removal of the account after the expiration time
echo "sed -i '/^### $user $exp/,/^},{/d' /etc/xray/config.json && systemctl restart xray" | at now + $expired minutes

clear
# Print the output JSON
echo "$OUTPUT" | jq .