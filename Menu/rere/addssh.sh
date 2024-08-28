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
useradd -e $(date -d "$expired days" +"%Y-%m-%d") -s /bin/false -M $username
exp="$(chage -l $username | grep "Account expires" | awk -F": " '{print $2}')"

# Set the user password
echo -e "$password\n$password\n" | passwd $username &> /dev/null
echo "$username:$password" | sudo chpasswd
tcpx="http://$domain:8081/tcp.ovpn"
udpx="http://$domain:8081/udp.ovpn"
wsx="GET / HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf]"
ovpnx="GET /ovpn HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf]"
ctls="chisel client wss://$domain:9443 R:5000:localhost:22 / chisel client https://$username:$password@$domain:9443 R:5000:localhost:22"
cth="chisel client ws://$domain:8000 R:5000:localhost:22 / chisel client http://$username:$password@$domain:8000 R:5000:localhost:22"
clear
# Generate the output JSON
OUTPUT=$(jq -n \
  --arg username "$username" \
  --arg password "$password" \
  --arg host_ip "$domain" \
  --arg nsdomain "$(cat /etc/slowdns/nsdomain)" \
  --arg pubkey "$(cat /etc/slowdns/server.pub)" \
  --arg expi "$exp" \
  --arg tcp "$tcpx" \
  --arg udp "$udpx" \
  --arg ws "$wsx" \
  --arg ovpn "$ovpnx" \
  --arg tlsc "$ctls" \
  --arg tlsh "$cth" \
  "{
    username: \$username,
    password: \$password,
    host_ip: \$host_ip,
    tls_ports: \"443\",
    non_tls_ports: \"80, 2082, 2080\",
    stunnel_ports: \"443\",
    ws_ovpn_port: \"443, 80\",
    openssh_ports: \"22, 3303, 53\",
    dropbear_ports: \"109, 69, 143\",
    udp_custom_ports: \"1-65535, 56-7789\",
    badvpn_port: \"7300\",
    slowdns_info: {
      port: \"5300\",
      public_key: \$pubkey,
      nameserver: \$nsdomain
    },
    chusel_info: {
      port_tls: \"9443\",
      port_http: \"8000\",
      chisel_tls: \$tlsc,
      chisel_http: \$tlsh
    },
    ovpn_info: {
      tcp: \$tcp,
      udp: \$udp
    },
    payloads: {
      ws: \$ws,
      ovpn: \$ovpn
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
