#!/bin/bash
#
#  |════════════════════════════════════════════════════════════════════════════════════════════════════════════════|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |════════════════════════════════════════════════════════════════════════════════════════════════════════════════|
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

# Generate UUID
uuid=$(xray uuid)

# Add user to config
sed -i '/#vless$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json

# Create Vless links
vlesslink1="vless://${uuid}@${domain}:443?path=/vlessws&security=tls&encryption=none&host=${domain}&type=ws&sni=${domain}#${user}"
vlesslink2="vless://${uuid}@${domain}:80?path=/vlessws&security=none&encryption=none&host=${domain}&type=ws#${user}"
vlesslink3="vless://$uuid@$domain:443?mode=gun&security=none&encryption=none&authority=$domain&type=grpc&serviceName=vless-grpc&sni=$domain#${user}"
vlesslink4="vless://${uuid}@${domain}:443?path=/rere-cantik&security=tls&encryption=none&host=${domain}&type=httpupgrade&sni=${domain}#${user}"
vlesslink5="vless://${uuid}@${domain}:80?path=/rere-cantik&security=none&encryption=none&host=${domain}&type=httpupgrade#${user}"
vlesslink6="vless://${uuid}@${domain}:443?path=%2Fvless-split&security=tls&encryption=none&alpn=h3,h2,http/1.1&host=${domain}&type=splithttp&sni=${domain}#${user}"
vlesslink7="vless://${uuid}@${domain}:80?path=/vless-split&security=none&encryption=none&host=${domain}&type=splithttp#${user}"

# Restart Xray service
systemctl daemon-reload
systemctl restart xray

# Generate output JSON
OUTPUT=$(jq -n \
  --arg domain "$domain" \
  --arg user "$user" \
  --arg uuid "$uuid" \
  --arg expired "$expired" \
  --arg vlesslink1 "$vlesslink1" \
  --arg vlesslink2 "$vlesslink2" \
  --arg vlesslink3 "$vlesslink3" \
  --arg vlesslink4 "$vlesslink4" \
  --arg vlesslink5 "$vlesslink5" \
  --arg vlesslink6 "$vlesslink6" \
  --arg vlesslink7 "$vlesslink7" \
  '{
    hostname: $domain,
    wildcard: ("bug.com." + $domain),
    remark: $user,
    uuid: $uuid,
    expired: "$expired Minutes",
    ports: {
      tls: "443",
      http: "80"
    },
    network: "Ws, HTTPUpgrade, SplitHTTP, gRPC",
    paths: {
      ws: "/vless | /vlessws",
      http: "/rere | /rere-cantik",
      split: "/vless-split"
    },
    serviceName: "vless-grpc",
    links: {
      ws_tls: $vlesslink1,
      ws_http: $vlesslink2,
      http_tls: $vlesslink4,
      http_ntls: $vlesslink5,
      split_tls: $vlesslink6,
      split_http: $vlesslink7,
      grpc: $vlesslink3
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