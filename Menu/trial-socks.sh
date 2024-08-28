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
clear
izp=$(cat /root/.isp)
region=$(cat /root/.region)
city=$(cat /root/.city)
domain=$(cat /etc/xray/domain)
clear
user=trial`</dev/urandom tr -dc 0-9 | head -c3`
pass="1"
masaaktif="1"
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#socks$/a\### '"$user $exp"'\
},{"user": "'""$user""'","pass": "'""$pass""'","email": "'""$user""'"' /etc/xray/config.json
echo -n "$user:$pass" | base64 > /tmp/log
socks_base64=$(cat /tmp/log)
sockslink1="socks://$socks_base64@$domain:443?path=/socks5&security=tls&host=$domain&type=ws&sni=$domain#$user"
sockslink2="socks://$socks_base64@$domain:80?path=/socks5&security=none&host=$domain&type=ws#$user"
rm -rf /tmp/log
systemctl restart xray
systemctl restart quota
clear
TEKS="
════════════════════════════
<=  X-Ray Socks5 Account  =>
════════════════════════════
Username      : ${user}
Password      : ${pass}
Domain        : ${domain}
Port TLS      : 443
Port NTLS     : 80
Network       : Websocket
Path          : /socks5
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
Link TLS      : ${sockslink1}
════════════════════════════
Link NTLS     : ${sockslink2}
════════════════════════════
Expired On    : 60 Minutes
════════════════════════════"
clear
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$TEKS" $URL
echo "sed -i '/^### $user $exp/,/^},{/d' /etc/xray/config.json && systemctl restart xray && systemctl restart quota" | at now + 60 minutes
clear
echo -e "$TEKS"
