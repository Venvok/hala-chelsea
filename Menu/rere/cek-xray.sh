#!/bin/bash

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