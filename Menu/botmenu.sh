#!/bin/bash
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
clear

lanjut() {
rm -fr /etc/funny/.chatid
rm -fr /etc/funny/.keybot
echo "$api" > /etc/funny/.keybot
echo "$itd" > /etc/funny/.chatid
clear
echo -e "
Your Data Bot Notirication
===========================
API Bot: $api
Chatid Own: $itd
===========================
"
}

add() {
clear
echo -e "
===================
[ 设置机7器人通知 ]
===================
"
read -p "API Key Bot: " api
read -p "Your Chat ID: " itd
clear
echo -e "
Information
==============================
API Bot: $api
Chatid : $itd
==============================
"
read -p "Is the data above correct? (y/n): " opw
case $opw in
y) clear ; lanjut ;;
n) clear ; add ;;
*) clear ; add ;;
esac
}

rpot() {
echo "
Report Bug To
=====================
Telegram:

- @Rerechan02
- @farell_aditya_ardian
- @PR_Aiman
=====================
Email:

- widyabakti02@gmail.com
=====================

Thanks For Use My Script
"
}

mna() {
echo -e "
======================
[   菜单设置机器人   ]
======================

1. Setup Bot Notification
2. Setup Bot Panel All Menu
3. Report Bug On Script
======================
Press CTRL + C to exit
"
read -p "Input Option: " apws
case $apws in
1) clear ; add ;;
2) clear ; echo "Coming Soon" ;;
3) clear ; rpot ;;
*) clear ; mna ;;
esac
}

mna
