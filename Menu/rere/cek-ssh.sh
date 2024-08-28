#!/bin/bash

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