#!/bin/bash
#
#  |═════════════════════════════════════════════════════════════════════════════════════======|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |═════════════════════════════════════════════════════════════════════════════════════======|
izp=$(cat /root/.isp)
region=$(cat /root/.region)
city=$(cat /root/.city)
domain=$(cat /etc/xray/domain)
clear
user=trial`</dev/urandom tr -dc 0-9 | head -c3`
masaaktif="1"
exp=`date -d "$masaaktif days" +"%y-%m-%d"`
uuid=${user}
sed -i '/#trojan$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
link1="trojan://${uuid}@${domain}:443?mode=gun&security=tls&authority=${domain}&type=grpc&serviceName=trojan-grpc&sni=${domain}#user"
link2="trojan://${uuid}@${domain}:443?path=%2ftrojanws&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
link3="trojan://${uuid}@${domain}:443?path=/dinda&security=tls&host=${domain}&type=httpupgrade&sni=${domain}#${user}"
link4="trojan://${uuid}@${domain}:443?path=/trojan-split&security=tls&host=${domain}&type=splithttp&sni=${domain}#${user}"
link5="trojan://${uuid}@${domain}:80?path=trojan-split&security=none&host=${domain}&type=splithttp#${user}"
systemctl daemon-reload ; systemctl restart xray
systemctl restart quota
clear
#HTTP TLS   : $link3
#════════════════════════════
#SPLIT HTTP : $link5
#════════════════════════════
#SPLIT TLS  : $link4
#════════════════════════════
clear
TEKS="
════════════════════════════
<=  X-Ray Trojan Account  =>
════════════════════════════

Remarks    : $user
Hostname   : $domain
WildCard   : bug.com.${domain}
Expired    : 60 Minutes
Password   : $uuid
════════════════════════════
WS HTTPS   : 443
WS HTTP    : 80
Path WS    : /trojan | /trojanws
Path HTTP  : /dinda | /dindaputri
Path Split : /trojan-split
ServiceName: trojan-grpc
════════════════════════════
<=   Detail Information   =>

ISP           : $izp
CITY          : $city
REGION        : $region
════════════════════════════
<=   DNSTT  Information   =>

Port         : 5300
Publik Key   : $(cat /etc/slowdns/server.pub)
Nameserver   : $(cat /etc/slowdns/nsdomain)
════════════════════════════
WebSocket  : $link2
════════════════════════════
gRPC       : $link1
════════════════════════════
"
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$TEKS" $URL
echo "sed -i '/^### $user $exp/,/^},{/d' /etc/xray/config.json && systemctl restart xray && systemctl restart quota" | at now + 60 minutes
clear
echo "$TEKS"
