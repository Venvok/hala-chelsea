#!/bin/bash
#
#  |═════════════════════════════════════════════════════════════════════════════════|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |═════════════════════════════════════════════════════════════════════════════════|
#
cekssh1() {

LOG=""

if [ -e "/var/log/auth.log" ]; then
    LOG="/var/log/auth.log"
fi
if [ -e "/var/log/secure" ]; then
    LOG="/var/log/secure"
fi

# Initialize JSON output
output="{\"dropbear_users\":[], \"openssh_users\":[], \"openvpn_tcp_users\":[], \"openvpn_udp_users\":[]}"

# Function to add user info to JSON
add_user_info() {
    local service=$1
    local pid=$2
    local user=$3
    local ip=$4
    output=$(echo $output | jq --arg service "$service" --arg pid "$pid" --arg user "$user" --arg ip "$ip" \
        '.[$service + "_users"] += [{"pid": $pid, "user": $user, "ip": $ip}]')
}

# Process Dropbear users
data=( $(ps aux | grep -i dropbear | awk '{print $2}') )
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/login-db.txt

for PID in "${data[@]}"
do
    cat /tmp/login-db.txt | grep "dropbear\[$PID\]" > /tmp/login-db-pid.txt
    NUM=$(cat /tmp/login-db-pid.txt | wc -l)
    USER=$(cat /tmp/login-db-pid.txt | awk '{print $10}')
    IP=$(cat /tmp/login-db-pid.txt | awk '{print $12}')
    if [ $NUM -eq 1 ]; then
        add_user_info "dropbear" "$PID" "$USER" "$IP"
    fi
done

# Process OpenSSH users
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/login-db.txt
data=( $(ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}') )

for PID in "${data[@]}"
do
    cat /tmp/login-db.txt | grep "sshd\[$PID\]" > /tmp/login-db-pid.txt
    NUM=$(cat /tmp/login-db-pid.txt | wc -l)
    USER=$(cat /tmp/login-db-pid.txt | awk '{print $9}')
    IP=$(cat /tmp/login-db-pid.txt | awk '{print $11}')
    if [ $NUM -eq 1 ]; then
        add_user_info "openssh" "$PID" "$USER" "$IP"
    fi
done

# Process OpenVPN TCP users
if [ -f "/etc/openvpn/server/openvpn-tcp.log" ]; then
    cat /etc/openvpn/server/openvpn-tcp.log | grep -w "^CLIENT_LIST" | cut -d ',' -f 2,3,8 | sed -e 's/,/ /g' > /tmp/vpn-login-tcp.txt
    while read -r line
    do
        USER=$(echo $line | awk '{print $1}')
        IP=$(echo $line | awk '{print $2}')
        CONNECTED=$(echo $line | awk '{print $3}')
        output=$(echo $output | jq --arg user "$USER" --arg ip "$IP" --arg connected "$CONNECTED" \
            '.openvpn_tcp_users += [{"user": $user, "ip": $ip, "connected": $connected}]')
    done < /tmp/vpn-login-tcp.txt
fi

# Process OpenVPN UDP users
if [ -f "/etc/openvpn/server/openvpn-udp.log" ]; then
    cat /etc/openvpn/server/openvpn-udp.log | grep -w "^CLIENT_LIST" | cut -d ',' -f 2,3,8 | sed -e 's/,/ /g' > /tmp/vpn-login-udp.txt
    while read -r line
    do
        USER=$(echo $line | awk '{print $1}')
        IP=$(echo $line | awk '{print $2}')
        CONNECTED=$(echo $line | awk '{print $3}')
        output=$(echo $output | jq --arg user "$USER" --arg ip "$IP" --arg connected "$CONNECTED" \
            '.openvpn_udp_users += [{"user": $user, "ip": $ip, "connected": $connected}]')
    done < /tmp/vpn-login-udp.txt
fi

# Print the JSON output
clear
echo $output | jq .

# Clean up temporary files
rm -f /tmp/login-db.txt /tmp/login-db-pid.txt /tmp/vpn-login-tcp.txt /tmp/vpn-login-udp.txt
}

hapus() {
clear
echo -e "\033[0;34m══════════════════════════════════════════\033[0m"
echo -e "\E[0;41;36m                 AKUN SSH               \E[0m"
echo -e "\033[0;34m══════════════════════════════════════════\033[0m"      
echo "USERNAME          EXP DATE          STATUS"
echo -e "\033[0;34m══════════════════════════════════════════\033[0m"
while read expired
do
AKUN="$(echo $expired | cut -d: -f1)"
ID="$(echo $expired | grep -v nobody | cut -d: -f3)"
exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
status="$(passwd -S $AKUN | awk '{print $2}' )"
if [[ $ID -ge 1000 ]]; then
if [[ "$status" = "L" ]]; then
printf "%-17s %2s %-17s %2s \n" "$AKUN" "$exp     " "${RED}LOCKED${NORMAL}"
else
printf "%-17s %2s %-17s %2s \n" "$AKUN" "$exp     " "${GREEN}UNLOCKED${NORMAL}"
fi
fi
done < /etc/passwd
JUMLAH="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
echo -e "\033[0;34m══════════════════════════════════════════\033[0m"
echo "Account number: $JUMLAH user"
echo -e "\033[0;34m══════════════════════════════════════════\033[0m"
echo ""
read -p "Username SSH to Delete : " Pengguna
if getent passwd $Pengguna > /dev/null 2>&1; then
        userdel $Pengguna > /dev/null 2>&1
        rm -fr /etc/funny/limit/ssh/ip/$Pengguna
        clear
        echo -e "User $Pengguna was removed."
        systemctl restart nginx
systemctl restart dropbear
else
clear
        echo -e "Failure: User $Pengguna Not Exist."
fi
}

renew() {
clear
echo -e "\e[33m══════════════════════════════════════════\033[0m"
echo -e "\E[40;1;37m               RENEW  USER                \E[0m"
echo -e "\e[33m══════════════════════════════════════════\033[0m"  
echo
read -p "Username : " User
egrep "^$User" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
read -p "Day Extend : " Days
Today=`date +%s`
Days_Detailed=$(( $Days * 86400 ))
Expire_On=$(($Today + $Days_Detailed))
Expiration=$(date -u --date="1970-01-01 $Expire_On sec GMT" +%Y/%m/%d)
Expiration_Display=$(date -u --date="1970-01-01 $Expire_On sec GMT" '+%d %b %Y')
passwd -u $User
usermod -e  $Expiration $User
egrep "^$User" /etc/passwd >/dev/null
echo -e "$Pass\n$Pass\n"|passwd $User &> /dev/null
clear
echo -e "\e[33m══════════════════════════════════════════\033[0m"
echo -e "\E[40;1;37m               RENEW  USER                \E[0m"
echo -e "\e[33m══════════════════════════════════════════\033[0m"  
echo -e ""
echo -e " Username : $User"
echo -e " Days Added : $Days Days"
echo -e " Expires on :  $Expiration_Display"
echo -e ""
echo -e "\e[33m══════════════════════════════════════════\033[0m"
else
clear
echo -e "\e[33m══════════════════════════════════════════\033[0m"
echo -e "\E[40;1;37m               RENEW  USER                \E[0m"
echo -e "\e[33m══════════════════════════════════════════\033[0m"  
echo -e ""
echo -e "   Username Doesnt Exist      "
echo -e ""
echo -e "\e[33m══════════════════════════════════════════\033[0m"
fi
}

mesinssh() {
clear
echo " "
echo " "

if [ -e "/var/log/auth.log" ]; then
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        LOG="/var/log/secure";
fi
                
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
echo "----------=[ Dropbear User Login ]=-----------";
echo "ID  |  Username  |  IP Address";
echo "----------------------------------------------";
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/login-db.txt;
for PID in "${data[@]}"
do
        cat /tmp/login-db.txt | grep "dropbear\[$PID\]" > /tmp/login-db-pid.txt;
        NUM=`cat /tmp/login-db-pid.txt | wc -l`;
        USER=`cat /tmp/login-db-pid.txt | awk '{print $10}'`;
        IP=`cat /tmp/login-db-pid.txt | awk '{print $12}'`;
        if [ $NUM -eq 1 ]; then
                echo "$PID - $USER - $IP";
                fi
done
echo " "
echo "----------=[ OpenSSH User Login ]=------------";
echo "ID  |  Username  |  IP Address";
echo "----------------------------------------------";
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/login-db.txt
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

for PID in "${data[@]}"
do
        cat /tmp/login-db.txt | grep "sshd\[$PID\]" > /tmp/login-db-pid.txt;
        NUM=`cat /tmp/login-db-pid.txt | wc -l`;
        USER=`cat /tmp/login-db-pid.txt | awk '{print $9}'`;
        IP=`cat /tmp/login-db-pid.txt | awk '{print $11}'`;
        if [ $NUM -eq 1 ]; then
                echo "$PID - $USER - $IP";
        fi
done
if [ -f "/etc/openvpn/server/openvpn-tcp.log" ]; then
echo ""
echo "---------=[ OpenVPN TCP User Login ]=---------";
echo "Username  |  IP Address  |  Connected";
echo "----------------------------------------------";
        cat /etc/openvpn/server/openvpn-tcp.log | grep -w "^CLIENT_LIST" | cut -d ',' -f 2,3,8 | sed -e 's/,/      /g' > /tmp/vpn-login-tcp.txt
        cat /tmp/vpn-login-tcp.txt
fi
echo "----------------------------------------------";

if [ -f "/etc/openvpn/server/openvpn-udp.log" ]; then
echo " "
echo "---------=[ OpenVPN UDP User Login ]=---------";
echo "Username  |  IP Address  |  Connected";
echo "----------------------------------------------";
        cat /etc/openvpn/server/openvpn-udp.log | grep -w "^CLIENT_LIST" | cut -d ',' -f 2,3,8 | sed -e 's/,/      /g' > /tmp/vpn-login-udp.txt
        cat /tmp/vpn-login-udp.txt
fi
echo "----------------------------------------------";
echo "";
}

cek() {
clear
clear
touch /root/.system
clear
echo -e "\033[0;34m═══════════════════════════════════\033[0m"
echo -e "     =[ SSH User Login ]=         "
echo -e "\033[0;34m═══════════════════════════════════\033[0m"
mulog=$(mesinssh)
data=( `cat /etc/passwd | grep home | cut -d ' ' -f 1 | cut -d : -f 1`);
for user in "${data[@]}"
do
cekcek=$(echo -e "$mulog" | grep $user | wc -l)
if [[ $cekcek -gt 0 ]]; then
echo -e "\e[33;1mUser\e[32;1m  : $user"
echo -e "\e[33;1mLogin\e[32;1m : $cekcek "
echo -e "\033[0;34m═══════════════════════════════════\033[0m"
echo "slot" >> /root/.system
else
echo > /dev/null
fi
sleep 0.1
done
aktif=$(cat /root/.system | wc -l)
echo -e "$aktif User Online"
echo -e "\033[0;34m═══════════════════════════════════\033[0m"
sed -i "d" /root/.system
}

member() {
clear
echo -e "\e[33m══════════════════════════════════════════\033[0m"
echo -e "\E[40;1;37m                 MEMBER SSH               \E[0m"
echo -e "\e[33m══════════════════════════════════════════\033[0m"      
echo "USERNAME          EXP DATE          STATUS"
echo -e "\e[33m══════════════════════════════════════════\033[0m"
while read expired
do
AKUN="$(echo $expired | cut -d: -f1)"
ID="$(echo $expired | grep -v nobody | cut -d: -f3)"
exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
status="$(passwd -S $AKUN | awk '{print $2}' )"
if [[ $ID -ge 1000 ]]; then
if [[ "$status" = "L" ]]; then
printf "%-17s %2s %-17s %2s \n" "$AKUN" "$exp     " "${RED}LOCKED${NORMAL}"
else
printf "%-17s %2s %-17s %2s \n" "$AKUN" "$exp     " "${GREEN}UNLOCKED${NORMAL}"
fi
fi
done < /etc/passwd
JUMLAH="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
echo -e "\e[33m══════════════════════════════════════════\033[0m"
echo "Account number: $JUMLAH user"
echo -e "\e[33m══════════════════════════════════════════\033[0m"
}

trial() {
clear
Login=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
masaaktif="1"
Pass="1"
clear
systemctl restart dropbear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
expi="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
hariini=`date -d "0 days" +"%Y-%m-%d"`
expi=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo "$Login:$Pass" | sudo chpasswd
domain=$(cat /etc/xray/domain)
clear
TEKS="
═══════════════════════════
<=      SSH ACCOUNT      =>
═══════════════════════════

Username     : $Login
Password     : $Pass
Host/IP      : $domain
Port ssl/tls : 443
Port non tls : 80, 2082
Port openssh : 22, 3303, 53
Port dropbear: 109, 69, 143
Udp Custom   : 1-65535, 56-7789
BadVpn       : 7300
═══════════════════════════
<=  Slowdns Information  =>
Port         : 5300, 5353
Publik Key   : $(cat /etc/slowdns/server.pub)
Nameserver   : $(cat /etc/slowdns/nsdomain)
═══════════════════════════
<=  Chisel  Information  =>
Port TLS     : 9443
Port HTTP    : 8000
TLS Usage    : chisel client wss://$domain:9443 R:5000:localhost:22 / chisel client https://$Login:$Pass@$domain:9443 R:5000:localhost:22
HTTP Usage   : chisel client ws://$domain:8000 R:5000:localhost:22 / chisel client http://$Login:$Pass@$domain:8000 R:5000:localhost:22
═══════════════════════════
Port OVPN    : 1194 TCP / 2200 UDP
OVPN TCP     : http://$domain:8081/tcp.ovpn
OVPN UDP     : http://$domain:8081/udp.ovpn
═══════════════════════════
Payload Ws   => GET / HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf]
═══════════════════════════
Payload Ovpn => GET /ovpn HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf][crlf]
═══════════════════════════
     Expired => $expi
═══════════════════════════
"
clear
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=$CHATID" --data-urlencode "text=$TEKS" $URL
clear
echo -e "$TEKS"
}

clear

menu-ssh() {
clear
edussh_service=$(systemctl status proxy | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $edussh_service == "running" ]]; then
ws="\e[1;32m[ ON ]\033[0m"
else
ws="\e[1;31m[ OFF ]\033[0m"
fi
eduss_service=$(systemctl status sslh | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $eduss_service == "running" ]]; then
slh="\e[1;32m[ ON ]\033[0m"
else
slh="\e[1;31m[ OFF ]\033[0m"
fi
edust_service=$(systemctl status edu | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $edust_service == "running" ]]; then
proxy1="\e[1;32m[ ON ]\033[0m"
else
proxy1="\e[1;31m[ OFF ]\033[0m"
fi
clear
echo -e "
══════════════════════════════════════════
        [ 菜单 SSH VPN 高级版  ]
══════════════════════════════════════════
WebSocket: $ws
SSLH Proxy: $slh
Goproxy Rerechan: $proxy1

1. Add Account SSH
2. Trial Account SSH
3. List SSH Account Member
4. Delete SSH Account Active
5. Renew SSH Account Active
6. Cek User Login SSH Account
7. Cek User Login SSH Account With API
══════════════════════════════════════════
       Press CTRL + C to Exit
"
read -p "Input Number: " opt
case $opt in
1) clear ; addssh ;;
2) clear ; trial-ssh ;;
3) clear ; member ;;
4) clear ; hapus ;;
5) clear ; renew ;;
6) clear ; cek ;;
7) clear ; cekssh1 ;;
*) clear ; menu-ssh :;
esac
}

menu-ssh
