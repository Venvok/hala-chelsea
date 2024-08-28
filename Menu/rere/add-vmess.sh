#!/bin/bash
clear
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
user=$(echo $POST_DATA | jq -r '.username')
expired=$(echo $POST_DATA | jq -r '.expired')

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
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterid": '"0"',"email": "'""$user""'"' /etc/xray/config.json

# Create VMess links
acs=$(cat <<EOF
{
  "v": "2",
  "ps": "${user}",
  "add": "${domain}",
  "port": "443",
  "id": "${uuid}",
  "aid": "0",
  "net": "ws",
  "path": "/vmessws",
  "type": "none",
  "host": "${domain}",
  "tls": "tls"
}
EOF
)
ask=$(cat <<EOF
{
  "v": "2",
  "ps": "${user}",
  "add": "${domain}",
  "port": "80",
  "id": "${uuid}",
  "aid": "0",
  "net": "ws",
  "path": "/worryfree",
  "type": "none",
  "host": "${domain}",
  "tls": "none"
}
EOF
)
grpc=$(cat <<EOF
{
  "v": "2",
  "ps": "${user}",
  "add": "${domain}",
  "port": "443",
  "id": "${uuid}",
  "aid": "0",
  "net": "grpc",
  "path": "vmess-grpc",
  "type": "none",
  "host": "${domain}",
  "tls": "tls"
}
EOF
)
hts=$(cat <<EOF
{
  "v": "2",
  "ps": "${user}",
  "add": "${domain}",
  "port": "80",
  "id": "${uuid}",
  "aid": "0",
  "net": "httpupgrade",
  "path": "/love-dinda",
  "type": "httpupgrade",
  "host": "${domain}",
  "tls": "none"
}
EOF
)
cs=$(cat <<EOF
{
  "v": "2",
  "ps": "${user}",
  "add": "${domain}",
  "port": "443",
  "id": "${uuid}",
  "aid": "0",
  "net": "httpupgrade",
  "path": "/love-dinda",
  "type": "httpupgrade",
  "host": "${domain}",
  "tls": "tls"
}
EOF
)
bpjs=$(cat <<EOF
{
  "v": "2",
  "ps": "${user}",
  "add": "${domain}",
  "port": "8880",
  "id": "${uuid}",
  "aid": "0",
  "net": "ws",
  "path": "/whatever",
  "type": "none",
  "host": "${domain}",
  "tls": "none"
}
EOF
)

split1=$(cat<<eof
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "splithttp",
"path": "/vmess-split",
"type": "splithttp",
"host": "${domain}",
"tls": "tls"
}
eof
)
split2=$(cat<<eof
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "80",
"id": "${uuid}",
"aid": "0",
"net": "splithttp",
"path": "/vmess-split",
"type": "splithttp",
"host": "${domain}",
"tls": "none"
}
eof
)

# Base64 encode VMess links
vmesslink1="vmess://$(echo $acs | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"
vmesslink4="vmess://$(echo $hts | base64 -w 0)"
vmesslink5="vmess://$(echo $cs | base64 -w 0)"
vmesslink6="vmess://$(echo $bpjs | base64 -w 0)"
vmesslink7="vmess://$(echo $split1 | base64 -w 0)"
vmesslink8="vmess://$(echo $split2 | base64 -w 0)"

# Restart Xray service
systemctl restart xray

# Generate output JSON
OUTPUT=$(jq -n \
  --arg domain "$domain" \
  --arg user "$user" \
  --arg uuid "$uuid" \
  --arg exp "$exp" \
  --arg vmesslink1 "$vmesslink1" \
  --arg vmesslink2 "$vmesslink2" \
  --arg vmesslink3 "$vmesslink3" \
  --arg vmesslink4 "$vmesslink4" \
  --arg vmesslink5 "$vmesslink5" \
  --arg vmesslink6 "$vmesslink6" \
  --arg vmesslink7 "$vmesslink7" \
  --arg vmesslink8 "$vmesslink8" \
  '{
    hostname: $domain,
    wildcard: ("bug.com." + $domain),
    remark: $user,
    uuid: $uuid,
    expired: $exp,
    ports: {
      tls: "443",
      http: "80"
    },
    network: "Ws, HTTPUpgrade, SplitHTTP, gRPC",
    paths: {
      ws: "/vmess | /vmessws",
      http: "/love | /love-dinda",
      split: "/vmess-split"
    },
    serviceName: "vmess-grpc",
    multipath: "/custom | /whatever",
    port_multipath: "8880",
    links: {
      ws_tls: $vmesslink1,
      ws_http: $vmesslink2,
      grpc: $vmesslink3,
      http_ntls: $vmesslink4,
      http_tls: $vmesslink5,
      split_tls: $vmesslink7,
      split_http: $vmesslink8,
      multipath: $vmesslink6
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