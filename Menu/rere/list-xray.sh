#!/bin/bash

# Set JSON output format
output="{\"users\":["

# Clear the access log
> /var/log/xray/accsess.log

# Read user data from config.json
data=( $(grep '###' /etc/xray/config.json | cut -d ' ' -f 2 | sort | uniq) )

for user in "${data[@]}"
do
    # Count the number of entries for the user
    jum=$(grep -c '###' /etc/xray/config.json | awk '{print $1}')
    
    if [[ $jum -gt 0 ]]; then
        exp=$(grep -wE "^### $user" /etc/xray/config.json | cut -d ' ' -f 3 | sort | uniq)
        output+="{\"user\":\"$user\", \"exp\":\"$exp\"},"
    fi
done

# Remove the trailing comma and close the JSON array
output=${output%,}
output+="],"

# Count the number of active members
aktif=$(echo "${data[@]}" | wc -w)
output+="\"active_members\": $aktif}"

# Print the JSON output
clear
echo $output | jq .