#!/bin/bash

# Initialize JSON output
output="{\"users\":["

while read expired; do
    AKUN="$(echo $expired | cut -d: -f1)"
    ID="$(echo $expired | grep -v nobody | cut -d: -f3)"
    exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}' | tr -d '[:space:]')"
    status="$(passwd -S $AKUN | awk '{print $2}')"

    if [[ $ID -ge 1000 ]]; then
        if [[ "$status" = "L" ]]; then
            output+="{\"username\":\"$AKUN\", \"exp_date\":\"$exp\", \"status\":\"LOCKED\"},"
        else
            output+="{\"username\":\"$AKUN\", \"exp_date\":\"$exp\", \"status\":\"UNLOCKED\"},"
        fi
    fi
done < /etc/passwd

# Remove the trailing comma and close the JSON array
output=${output%,}
output+="],"

# Add the account number
JUMLAH="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
output+="\"account_number\": $JUMLAH}"

# Print JSON output
echo $output | jq .