#!/bin/bash
clear

echo -e "|                          X-Ray Database                                           |"
echo -e "|———————————————————————————————————————————————————————————————————————————————————|"

# Fungsi untuk mengonversi byte ke format yang mudah dibaca
con() {
    local -i bytes=$1
    if [[ $bytes -lt 1024 ]]; then
        echo "${bytes} B"
    elif [[ $bytes -lt 1048576 ]]; then
        echo "$(( (bytes + 1023) / 1024 )) KB"
    elif [[ $bytes -lt 1073741824 ]]; then
        echo "$(( (bytes + 1048575) / 1048576 )) MB"
    else
        echo "$(( (bytes + 1073741823) / 1073741824 )) GB"
    fi
}

# Membaca daftar pengguna dari file konfigurasi
users=( $(grep '###' /etc/xray/config.json | cut -d ' ' -f 2 | sort | uniq) )

for user in "${users[@]}"; do
    # Mengambil tanggal kedaluwarsa pengguna
    expired=$(grep "### $user" /etc/xray/config.json | cut -d ' ' -f 3 | sort | uniq)

    # Mengambil kuota dan penggunaan pengguna
    limit_file="/etc/xray/quota/$user"
    usage_file="/etc/xray/quota/${user}_usage"

    if [[ -f "$limit_file" ]]; then
        tot=$(cat "$limit_file")
        limit=$(con $tot)
    else
        limit="Unlimited"
    fi

    if [[ -f "$usage_file" ]]; then
        pakai=$(cat "$usage_file")
        usage=$(con ${pakai})
    else
        usage="0 B"
    fi

    # Mengambil log yang terkait dengan pengguna
    logs=$(grep "email: $user" /var/log/xray/access.log)

    # Menyimpan IP unik dalam file sementara
    echo "$logs" | awk '{print $5}' | sed 's/tcp://;s/udp://;s/:443//;s/:80//' | head -n 5 | sort | uniq > /tmp/ip

    # Menghitung jumlah baris dalam file IP
    jum2=$(wc -l < /tmp/ip)

    echo -e "                           Detail Account\n"
    echo -e " Username   : $user"
    echo -e " Expired On : $expired"
    echo -e " Limit Quota: $limit"
    echo -e " Usage Quota: $usage"
    echo -e " Total IP Access: $jum2"
    echo -e "|——————————————————————————————————————————————————————————————————————————————————|"
    echo -e "|       Logs Time     |     Destination IP   |        Provider Client             "
    echo -e "|——————————————————————————————————————————————————————————————————————————————————|"

    if [[ -n "$logs" ]]; then
        echo "$logs" | head -n 5 | while read -r log_entry; do
            ip_server=$(echo "$log_entry" | awk '{print $3}')
            logs_time=$(echo "$log_entry" | awk '{print $1, $2}')
#            method=$(echo "$log_entry" | awk -F'[][]' '{print $2}')
            ip_tujuan=$(echo "$log_entry" | awk '{print $5}')
            clean_ip=$(echo "$ip_server" | awk -F':' '{print $1}')
            provide=$(curl -s "http://ip-api.com/json/$clean_ip" | jq -r '.isp')
            echo -e "| $logs_time | $ip_tujuan | $provide"
        done
    else
        echo -e "                 No logs available on database server......."
    fi

    echo -e "|——————————————————————————————————————————————————————————————————————————————————|"
done