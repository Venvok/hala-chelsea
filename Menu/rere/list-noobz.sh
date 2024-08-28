#!/bin/bash
output=$(cat /etc/noobzvpns/users.json)
# Print the JSON output
clear
echo $output | jq .