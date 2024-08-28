#!/bin/bash
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
acme() {
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

cert2() {
email="faraskun02@gmail.com"
domain=$(cat /etc/xray/domain)

clear
echo "
L FN 项目更新证书
=================================
Your Domain: $domain
=================================
4 For IPv4 & 6 For IPv6
"
echo -e "Generate new Certificate. Please input your VPS type:"
read -p "Input Your Type Pointing (4 for IPv4 / 6 for IPv6): " ip_version

stop_services() {
    systemctl stop haproxy
    systemctl stop nginx
}

start_services() {
    systemctl start haproxy
    systemctl start nginx
}

copy_certificates() {
    cat /etc/letsencrypt/live/$domain/fullchain.pem >> /etc/xray/xray.crt
    cat /etc/letsencrypt/live/$domain/privkey.pem >> /etc/xray/xray.key
    cd /etc/xray
    cat xray.crt xray.key >> /etc/xray/funny.pem
    chmod 644 /etc/xray/xray* /etc/xray/*.pem
    cd
}

if [[ $ip_version == "4" || $ip_version == "6" ]]; then
    stop_services
    if [[ $ip_version == "4" ]]; then
        certbot certonly --standalone --preferred-challenges http -d $domain --non-interactive --agree-tos --email $email
    elif [[ $ip_version == "6" ]]; then
        certbot certonly --standalone --preferred-challenges http -d $domain --non-interactive --agree-tos --email $email --preferred-challenges http --standalone-supported-challenges http
    fi

    copy_certificates
    start_services
    echo "Cert installed for IPv$ip_version."
else
    echo "Invalid IP version. Please choose '4' for IPv4 or '6' for IPv6."
    sleep 3
    cert2
fi
}

dm() {
clear
echo -e "\e[33m===================================\033[0m"
echo -e "Domain anda saat ini:"
echo -e "$(cat /etc/xray/domain)"
echo ""
read -rp "Domain/Host: " -e host
echo ""
if [ -z $host ]; then
echo "DONE CHANGE DOMAIN"
echo -e "\e[33m===================================\033[0m"
read -n 1 -s -r -p "Press any key to back on menu"
menu
else
echo "$host" > /etc/xray/domain
echo -e "\e[33m===================================\033[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to renew cert"
cert
fi
}

fn() {
clear
echo start
domain=$(cat /etc/xray/domain)
systemctl stop nginx
systemctl stop haproxy
cd /root/
clear
echo "starting...., Port 80 Akan di Hentikan Saat Proses install Cert"
certbot certonly --standalone --preferred-challenges http --agree-tos --email melon334456@gmail.com -d $domain 
cp /etc/letsencrypt/live/$domain/fullchain.pem /etc/xray/xray.crt
cp /etc/letsencrypt/live/$domain/privkey.pem /etc/xray/xray.key
cd /etc/xray
cat xray.crt xray.key >> /etc/xray/funny.pem
chmod 644 /etc/xray/xray.key
chmod 644 /etc/xray/xray.crt
chmod 644 /etc/xray/funny.pem
systemctl start haproxy
systemctl start nginx
}

cert() {
clear
echo -e "
========================
[ Generate Certificate ]
========================

1. Use Acme
2. Use Certbot
========================
"
read -p "Input Option: " akz
case $akz in
1) acme ;;
2) cert2 ;;
*) cert ;;
esac
}

dmsl() {
systemctl stop haproxy nginx
clear
#detail nama perusahaan
country="ID"
state="Central Kalimantan"
locality="Kab. Kota Waringin Timur"
organization="FN Project"
organizationalunit="99999"
commonname="FN"
email="rerechan0202@gmail.com"

# delete
rm -fr /etc/xray/xray.*
rm -fr /etc/xray/funny.pem

# make a certificate
openssl genrsa -out /etc/xray/xray.key 2048
openssl req -new -x509 -key /etc/xray/xray.key -out /etc/xray/xray.crt -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat /etc/xray/xray.key /etc/xray/xray.crt >> /etc/xray/funny.pem
chmod 644 /etc/xray/*

systemctl daemon-reload
service nginx restart
service haproxy restart
echo -e "Done Generate New Certificate"
}

dm1() {
clear
echo -e "
=================================
[ 菜单子域指向服务器 Cloudflare ]
=================================

1. Use Your Domain
2. Renew Certificate ( VPS IPv6 & IPv4 ) Acme
3. Renew Certificate ( VPS IPv4 Only ) Let's encrypt
4. Generare Direct Certificate ( VPS IPv4 Only ) Direct FN Project
=================================
     Press CTRL + C to Exit
"
read -p "Input Option: " apw
case $apw in
1) clear ; dm ;;
2) clear ; cert ;;
3) clear ; fn ;;
4) clear ; dmsl ;;
*) dm1 ;;
esac
}

dm1
