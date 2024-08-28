#!/bin/bash
clear
# @Rerechan02 | @fn_project Telegram
# This code is just a sample
# ___________________________________________

# the domain you want to ping test
url="nhentai.net"
# do a ping check against the url and cut only the ping text
ping=$(ping_result=$(ping -c 1 $url | grep -oP 'time=\K\d+\.\d+')
if (( $(echo "$ping_result < 100" | bc -l) )); then
    echo -e "\e[32m$ping_result ms\e[0m"
elif (( $(echo "$ping_result < 200" | bc -l) )); then
    echo -e "\e[33m$ping_result ms\e[0m"
else
    echo -e "\e[31m$ping_result ms\e[0m"
fi)
clear
# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"
DATE2=$(date -R | cut -d " " -f -5)
tram=$(free -m | awk 'NR==2 {print $2}')
uram=$(free -m | awk 'NR==2 {print $3}')
fram=$(free -m | awk 'NR==2 {print $4}')
nama=$(cat /etc/xray/.email)
# // Exporting Language to UTF-8
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
UWhite='\033[4;37m'       # White
On_IPurple='\033[0;105m'  #
On_IRed='\033[0;101m'
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
NC='\e[0m'
#Download/Upload today
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload yesterday
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload current month
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"
clear

# // Exporting Language to UTF-8

export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'


# // Export Color & Information
export red='\033[0;31m'
export green='\033[0;32m'
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# // Export Banner Status Information
export EROR="[${RED} EROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"

# // Clear
clear
cek=$(service ssh status | grep active | cut -d ' ' -f5)
if [ "$cek" = "active" ]; then
stat=-f5
else
stat=-f7
fi
ssh=$(service ssh status | grep active | cut -d ' ' $stat)
if [ "$ssh" = "active" ]; then
ressh="${green}ON${NC}"
else
ressh="${red}OFF${NC}"
fi
sshstunel=$(service sslh status | grep active | cut -d ' ' $stat)
if [ "$sshstunel" = "active" ]; then
resst="${green}ON${NC}"
else
resst="${red}OFF${NC}"
fi
sshws=$(service edu status | grep active | cut -d ' ' $stat)
if [ "$sshws" = "active" ]; then
ressshws="${green}ON${NC}"
else
ressshws="${red}OFF${NC}"
fi
ngx=$(service nginx status | grep active | cut -d ' ' $stat)
if [ "$ngx" = "active" ]; then
resngx="${green}ON${NC}"
else
resngx="${red}OFF${NC}"
fi
dbr=$(service dropbear status | grep active | cut -d ' ' $stat)
if [ "$dbr" = "active" ]; then
resdbr="${green}ON${NC}"
else
resdbr="${red}OFF${NC}"
fi
v2r=$(service xray status | grep active | cut -d ' ' $stat)
if [ "$v2r" = "active" ]; then
resv2r="${green}ON${NC}"
else
resv2r="${red}OFF${NC}"
fi
m1=$(curl -s ifconfig.me)
m2=$(curl -s ifconfig.me)
IP="$m1 / $m2"
clear
echo -e "\e[33m ==================================================\033[0m" | lolcat
echo -e "                 • FN Project 1.5 •                 "
echo -e "\e[33m ==================================================\033[0m" | lolcat
echo -e "\e[33m OS            \e[0m:  "`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`
echo -e "\e[33m IP            \e[0m:  $IP"
echo -e "\e[33m RAM           \e[0m:  $uram MB / $tram MB"
echo -e "\e[33m ISP           \e[0m:  $(cat /root/.isp)"
echo -e "\e[33m CITY          \e[0m:  $(cat /root/.city)"
echo -e "\e[33m DOMAIN        \e[0m:  $(cat /etc/xray/domain)"
echo -e "\e[33m DATE & TIME   \e[0m:  $DATE2"
echo -e "\e[33m UPTIME        \e[0m:  $uptime"
echo -e "\e[33m Your Ping     \e[0m:  $ping \e[037;1m [ $url ]"
echo -e "\e[33m ==================================================\033[0m" | lolcat
echo -e " ${BICyan}SSH${NC}: $ressh"" ${BICyan}NGINX${NC}: $resngx"" ${BICyan}X-RAY${NC}: $resv2r"
echo -e " ${BICyan}STUNNEL${NC}: $resst"" ${BICyan}DROPBEAR${NC}: $resdbr"" ${BICyan}WS${NC}: $ressshws "
echo -e "\e[33m ==================================================\033[0m" | lolcat
echo -e " \e[33mClient Name   \E[0m: @Rerechan02"
echo -e " \e[33mScrip Version \E[0m: FN Project X Rerechan02"
echo -e "\e[33m ==================================================\033[0m" | lolcat
echo -e "      ${white} type to access all panel ${WARNING}=> ${BICyan}menu${NC}"
