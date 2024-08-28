#!/bin/bash
clear
api="6187251915:AAH_6YqHWpElw-S7_n5208ibAEvHWshk6jg"
id="5979008084"
clear
echo -e "
====================
[  Report your Bug ]
====================

Note:
The bug will be read by the admin, if your bug is a problem in the new script your report will be answered by the admin, If the bug in the script is your own fault, you are not allowed to report it and the admin will not take care of your problem.
~ Farell Aditya Ardian Pratama Putra Utama
"
read -p "Describe the bug you are experiencing: " apws
read -p "Input Your WhatsApp Number or Telegram Username: " user

teks="
Report Bug📣📣
By $user
=======================

Complaint: $apws
======================="
TIME="10"
URL="https://api.telegram.org/bot${api}/sendMessage"
curl -s --max-time $TIME --data-urlencode "chat_id=${id}" --data-urlencode "text=${teks}" $URL
clear
echo -e "


Thank you for providing feedback, your feedback will be immediately read and replied to by the Admin. If no reply means this is not a problem with the script.
~ Farell Aditya Ardian Pratama Putra Utama
"
