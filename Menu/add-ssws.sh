#!/bin/bash
izp=$(cat /root/.isp)
region=$(cat /root/.region)
city=$(cat /root/.city)
clear
domain=$(cat /etc/xray/domain)
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
clear
echo -e "
════════════════════════════════
<= Create ShadowSocks Account =>
════════════════════════════════"
read -rp "User: " -e user
CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
echo -e "
Udah Ada Akunya"
fi
done
cipher="aes-128-gcm"
pwss=$(echo $RANDOM | md5sum | head -c 6; echo;)
read -p "Expired (days): " masaaktif
read -p "Limit Quota   : " quota
if [[ $quota -gt 0 ]]; then
echo -e "$[$quota * 1024 * 1024 * 1024]" > /etc/funny/limit/trojan/quota/$user
else
echo > /dev/null
fi
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#ss$/a\### '"$user $exp"'\
},{"password": "'""$pwss""'","method": "'""$cipher""'","email": "'""$user""'"' /etc/xray/config.json
echo -n "$cipher:$pwss" | base64 -w 0 > /tmp/log
ss_base64=$(cat /tmp/log)
shadowsockslink1="ss://${ss_base64}@$domain:443?path=/ssws&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
shadowsockslink2="ss://${ss_base64}@$domain:80?path=/ssws&security=none&host=${domain}&type=ws#${user}"
rm -rf /tmp/log
systemctl restart xray
systemctl restart quota
clear
TEKS="
════════════════════════════
<=   ShadowSock Account   =>
════════════════════════════
Username   : ${user}
Host / IP  : ${domain}
Password   : $pwss
Expired    : $exp
════════════════════════════
Port TLS   : 443
Port NTLS  : 80
Cipher     : ${cipher}
Network    : Websocket, gRPC
Path       : /ssws
Alpn       : h2, http/1.1
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
Link TLS : ${shadowsockslink1}
════════════════════════════
Link NTLS: ${shadowsockslink2}
════════════════════════════"
clear
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$TEKS" $URL
clear
echo -e "$TEKS"
