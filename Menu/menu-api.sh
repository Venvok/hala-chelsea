#!/bin/bash
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#

clear
generate() {
mds=$(cat /etc/xray/.key)
clear
echo -e "Generating New Key"
sleep 5
clear
xray uuid >> /etc/xray/.key
clear
systemctl daemon-reload
systemctl restart server
echo -e "
Success Generate New Key
========================
Your API Token:
$mds
========================
"
}

manual() {
mds=$(cat /etc/xray/.key)
clear
echo -e "
Add New Token API
=================
"
read -p "Input Token: " token
sleep 5
echo $token >> /etc/xray/.key
systemctl daemon-reload
systemctl restart server
clear
echo -e "
Success Add New Key API
========================
Your API Token:
$mds
========================
"
}

manual31() {
nano /etc/xray/.key
}

cert() {
clear
echo start
clear
domain=$(cat /etc/xray/domain)
clear
echo "
L FN 项目更新证书
=================================
Your Domain: $domain
=================================
4 For IPv4 &  For IPv6
"
echo -e "Generate new Ceritificate Please Input Type Your VPS"
read -p "Input Your Type Pointing ( 4 / 6 ): " ip_version
if [[ $ip_version == "4" ]]; then
    systemctl stop nginx
    systemctl stop haproxy
    mkdir /root/.acme.sh
    curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
    chmod +x /root/.acme.sh/acme.sh
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d $domain --force --standalone -k ec-256
    ~/.acme.sh/acme.sh --installcert -d $domain --force --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    cd /etc/xray
    cat xray.crt xray.key >> /etc/xray/funny.pem
    chmod 644 /etc/xray/xray* /etc/xray/*.pem
    cd
    systemctl start haproxy
    systemctl start nginx
    echo "Cert installed for IPv4."
elif [[ $ip_version == "6" ]]; then
    systemctl stop nginx
    systemctl stop haproxy
    mkdir /root/.acme.sh
    curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
    chmod +x /root/.acme.sh/acme.sh
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d $domain --force --standalone -k ec-256 --listen-v6
    ~/.acme.sh/acme.sh --installcert -d $domain --force --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    cd /etc/xray
    cat xray.crt xray.key >> /etc/xray/funny.pem
    chmod 644 /etc/xray/xray* /etc/xray/*.pem
    cd
    systemctl start haproxy
    systemctl start nginx
    echo "Cert installed for IPv6."
else
    echo "Invalid IP version. Please choose '4' for IPv4 or '6' for IPv6."
    sleep 3
    cert
fi
}

enable() {
clear
echo -e "Enable API"
sleep 5
clear
systemctl daemon-reload
systemctl enable server
systemctl start server
clear
echo -e "Done Enable API"
}

restart() {
echo -e "Restarting API"
systemctl daemon-reload
systemctl enable server
systemctl start server
systemctl restart server
clear
echo -e "Done Restarting API"
}

disable() {
echo -e "Disable API"
sleep 5
clear
systemctl stop server
systemctl disable server
clear
echo -e "Success Disable API"
}

detail() {
domain=$(cat /etc/xray/domain)
edust_service=$(systemctl status server | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
if [[ $edust_service == "running" ]]; then
proxy1="\e[1;32m[ ON ]\033[0m"
else
proxy1="\e[1;31m[ OFF ]\033[0m"
fi
clear
echo -e "
<= Menu Web API =>
==================
With Port:
- http://${domain}:9000/path
==================
Default Port:
- http://${domain}/api/path
- https://${domain}/api/path
==================
Status: $proxy1

1. Generate New Key Token
2. Change Manual Key Token
3. Add Key Token API
4. Fix default https Certificate
5. Enable API
6. Restart API
7. Disable API
0. Back To Default Menu
==================
"
read -p "Input Option: " opw
case $opw in
1) clear ; generate ; exit ;;
2) clear ; manual31 ; exit ;;
3) clear ; manual ; exit ;;
4) clear ; cert ; exit ;;
5) clear ; enable ; exit ;;
6) clear ; restart ; exit ;;
7) clear ; disable ; exit ;;
0) clear ; menu ; exit ;;
*) clear ; detail ; exit ;;
esac
}

detail
