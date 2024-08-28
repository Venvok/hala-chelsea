#!/bin/bash
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
clear

cek() {
con() {
    local -i bytes=$1;
    if [[ $bytes -lt 1024 ]]; then
        echo "${bytes}B"
    elif [[ $bytes -lt 1048576 ]]; then
        echo "$(( (bytes + 1023)/1024 ))KB"
    elif [[ $bytes -lt 1073741824 ]]; then
        echo "$(( (bytes + 1048575)/1048576 ))MB"
    else
        echo "$(( (bytes + 1073741823)/1073741824 ))GB"
    fi
}
RED='\e[31m'
GREEN='\e[32m'
NC='\033[0;37m'
white='\033[0;97m'
data=( `cat /etc/xray/config.json | grep '###' | cut -d ' ' -f 2 | sort | uniq`);
limit=$(cat /etc/xray/quota/$data)
usage_file="/etc/xray/quota/${data}_usage"
pakai=$(cat "$usage_file")
usage=$(con ${pakai})
clear
echo -n > /tmp/other.txt
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "     =[ ALL-XRAY User Login ]=         "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
for akun in "${data[@]}"
do
if [[ -z "$akun" ]]; then
akun="tidakada"
fi
echo -n > /tmp/ipxray.txt
data2=( `cat /var/log/xray/access.log | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq`);
for ip in "${data2[@]}"
do
jum=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort | uniq)
if [[ "$jum" = "$ip" ]]; then
echo "$jum" >> /tmp/ipxray.txt
else
echo "$ip" >> /tmp/other.txt
fi
jum2=$(cat /tmp/ipxray.txt)
sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
done
jum=$(cat /tmp/ipxray.txt)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
jum2=$(cat /tmp/ipxray.txt | nl)
lastlogin=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 2 | tail -1)
echo -e "
user :${GREEN} ${akun} ${NC}
${RED}Online Jam ${NC}:${white} ${lastlogin} wib
${RED}Limit Quota${NC}:${GREEN} ${limit}
${RED}Usage Quota${NC}:${GREEN} ${usage}
";
echo -e "$jum2";
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
fi
rm -rf /tmp/ipxray.txt
done
rm -rf /tmp/other.txt

echo ""
}

dell() {
NC='\e[0m'
GB='\e[32;1m'
YB='\e[33;1m'
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "                ${GB}Delete V2ray Account${NC}                "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "  ${YB}You have no existing clients!${NC}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -n 1 -s -r -p "Press any key to back on menu"
menu-xray
fi
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "                ${GB}Delete V2ray Account${NC}                "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " ${YB}User  Expired${NC}  "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq
echo ""
echo -e "${YB}tap enter to go back${NC}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -rp "Input Username : " user
if [ -z $user ]; then
menu-xray
else
exp=$(grep -wE "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json
systemctl restart xray
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "           ${GB}V2ray Account Success Deleted${NC}            "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " ${YB}Client Name :${NC} $user"
echo -e " ${YB}Expired On  :${NC} $exp"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
fi
}

ren() {
NC='\e[0m'
GB='\e[32;1m'
YB='\e[33;1m'
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/xray/config.json")
if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "                ${GB}Extend V2ray Account${NC}               "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "  ${YB}You have no existing clients!${NC}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu-xray
fi
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "                ${GB}Extend V2ray Account${NC}               "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " ${YB}User  Expired${NC}  "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
grep -E "^### " "/etc/xray/config.json" | cut -d ' ' -f 2-3 | column -t | sort | uniq
echo ""
echo -e "${YB}tap enter to go back${NC}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -rp "Input Username : " user
if [ -z $user ]; then
menu-xray
else
read -p "Expired (days): " masaaktif
exp=$(grep -wE "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "/### $user/c\### $user $exp4" /etc/xray/config.json
systemctl restart xray
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "           ${GB}V2ray Account Success Extended${NC}            "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " ${YB}Client Name :${NC} $user"
echo -e " ${YB}Expired On  :${NC} $exp4"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
fi
}

mx() {
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "     =[ Member V2ray Account ]=         "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -n > /var/log/xray/accsess.log
data=( `cat /etc/xray/config.json | grep '###' | cut -d ' ' -f 2 | sort | uniq`);
for user in "${data[@]}"
do
echo > /dev/null
jum=$(cat /etc/xray/config.json | grep -c '###' | awk '{print $1}')
if [[ $jum -gt 0 ]]; then
exp=$(grep -wE "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
echo -e "\e[33;1mUser\e[32;1m  : $user / $exp "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo "slot" >> /root/.system
else
echo > /dev/null
fi
sleep 0.1
done
aktif=$(cat /root/.system | wc -l)
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"        
echo -e "$aktif Member Active"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sed -i "d" /root/.system
}

mlbb() {
RED='\e[31m'
GREEN='\e[32m'
NC='\033[0;37m'
clear

# Prepare temporary files
echo -n > /tmp/other.txt
echo -n > /tmp/ipxray.txt

# Get unique users from the config
data=( $(cat /etc/xray/config.json | grep '###' | cut -d ' ' -f 2 | sort | uniq) )

# Begin JSON output
echo '{' > /tmp/output.json
echo '"users": [' >> /tmp/output.json

first_user=true

for akun in "${data[@]}"
do
    if [[ -z "$akun" ]]; then
        akun="tidakada"
    fi

    echo -n > /tmp/ipxray.txt
    data2=( $(cat /var/log/xray/access.log | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | sort | uniq) )

    for ip in "${data2[@]}"
    do
        jum=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 3 | sed 's/tcp://g' | cut -d ":" -f 1 | grep -w "$ip" | sort | uniq)
        if [[ "$jum" = "$ip" ]]; then
            echo "$jum" >> /tmp/ipxray.txt
        else
            echo "$ip" >> /tmp/other.txt
        fi
        jum2=$(cat /tmp/ipxray.txt)
        sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
    done

    jum=$(cat /tmp/ipxray.txt)
    if [[ -z "$jum" ]]; then
        continue
    else
        if ! $first_user; then
            echo ',' >> /tmp/output.json
        fi
        first_user=false

        lastlogin=$(cat /var/log/xray/access.log | grep -w "$akun" | tail -n 500 | cut -d " " -f 2 | tail -1)
        ip_list=$(cat /tmp/ipxray.txt | nl | awk '{print "\"" $2 "\""}' | paste -sd, -)

        echo "{" >> /tmp/output.json
        echo "\"user\": \"$akun\"," >> /tmp/output.json
        echo "\"last_login\": \"$lastlogin\"," >> /tmp/output.json
        echo "\"ips\": [$ip_list]" >> /tmp/output.json
        echo "}" >> /tmp/output.json
    fi

    rm -rf /tmp/ipxray.txt
done

# End JSON output
echo ']' >> /tmp/output.json
echo '}' >> /tmp/output.json

# Format the JSON output using jq
clear
jq . /tmp/output.json

# Clean up temporary files
rm -rf /tmp/other.txt
rm -rf /tmp/output.json
}

uix() {
clear
echo -e "══════════════════════════" | lolcat
echo -e " <= UUID V2RAY ACCOUNT =>"
echo -e "══════════════════════════" | lolcat
grep -oP '(?<=id": ")[^"]+' /etc/xray/*.json | sort -u
echo -e "══════════════════════════" | lolcat
read -p "Input Old UUID Account: " user
read -p "Input New UUID Account: " uuid
sed -i "s|\"id\": \"$user\"|\"id\": \"$uuid\"|" /etc/xray/*.json
systemctl daemon-reload ; systemctl restart xray
clear
echo -e "══════════════════════════" | lolcat
echo -e " <= SUCCES CHANGE UUID =>"
echo -e "══════════════════════════" | lolcat
echo -e "OLD UUID ACCOUNT: $user "
echo -e "NEW UUID ACCOUNT: $uuid "
echo -e "══════════════════════════" | lolcat
}

uit() {
clear
echo -e "═════════════════════════════" | lolcat
echo -e "<= PASSWORD TROJAN ACCOUNT =>"
echo -e "═════════════════════════════" | lolcat
grep -oP '(?<=password": ")[^"]+' /etc/xray/*.json | sort -u
echo -e "══════════════════════════" | lolcat
read -p "Input Old Password Account: " user
read -p "Input New Password Account: " uuid
sed -i "s|\"id\": \"$user\"|\"id\": \"$uuid\"|" /etc/xray/*.json
systemctl daemon-reload ; systemctl restart xray
clear
echo -e "═════════════════════════════" | lolcat
echo -e "<= SUCCES CHANGE PASSWORD  => "
echo -e "═════════════════════════════" | lolcat
echo -e "OLD Password ACCOUNT: $user "
echo -e "NEW Password ACCOUNT: $uuid "
echo -e "═════════════════════════════" | lolcat
}

menu-xray() {
red='\e[1;31m'
green='\e[1;32m'
#pink='\e[1;35m'
NC='\e[0m'
clear
echo -e "
==============================
  [ 菜单数据 V2ray 管理器 ]
=============================="
status="$(systemctl show xray.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e "${white}V2射线 状态 ${NC}: "${green}"running"$NC" ✓"
else
echo -e "${white}V2射线 状态 ${NC}: "$red"not running (Error)"$NC" "
fi
status="$(systemctl show nginx.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e "${white}负载均衡${NC}: "${green}"running"$NC" ✓"
else
echo -e "${white}负载均衡${NC}: "$red"not running (Error)"$NC" "
fi
#V2ray 状态： $xtr
#负载均衡器： $ng
echo "
01. Create Account Vmess
02. Create Account Vless
03. Create Account Trojan
04. Create Account Shadowsocks
05. Create Account X-Ray Socks5
==============================

06. Trial Account Vmess
07. Trial Account Vless
08. Trial Account Trojan
09. Trial Account Socks5
10. Trial Account Shadowsocks
==============================

11. Cek User Login V2ray with API
12. Cek User Login Usage V2ray
13. Renew Account V2ray With Name
14. Delete Account V2ray With Username
15. Change UUID V2ray Account With UUID
16. Change Password Trojan Account With Password
17. Cek Total List Member Activa in server with Database
18. Show X-Ray Active Account on Database Server
==============================
   Press CTRL + C to exit
"
read -p "Input Option: " opw
case $opw in
01|1) clear ; add-vmess ;;
02|2) clear ; add-vless ;;
03|3) clear ; add-trojan ;;
04|4) clear ; add-ssws ;;
05|5) clear ; add-socks ;;
06|6) clear ; trial-vmess ;;
07|7) clear ; trial-vless ;;
08|8) clear ; trial-trojan ;;
09|9) clear ; trial-socks ;;
10) clear ; trial-ssws ;;
11) clear ; mlbb ;;
12) clear ; cek ;;
13) clear ; ren ;;
14) clear ; dell ;;
15) clear ; uix ;;
16) clear ; uit ;;
17) clear ; mx ;;
18) clear ; log-xray ;;
*) clear ; menu-xray ;;
esac
}

menu-xray
