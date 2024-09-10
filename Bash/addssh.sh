#!/bin/bash
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
clear
echo -e "
===================
[ Add Account SSH ]
===================
"
read -p "Username: " Login
read -p "Password: " Pass
read -p "Active time: " masaaktif
clear
clear
systemctl restart dropbear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
expi="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
hariini=`date -d "0 days" +"%Y-%m-%d"`
expi=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo "$Login:$Pass" | sudo chpasswd
clear
TEKS="
==================================
[ Informasi 帐户 SSH VPN 高级版  ]
==================================

Hostname: $(cat /etc/xray/domain)
Username: $Login
Password: $Pass
Expired : $expi
==================================

WS HTTP   : 80, 2082, 2080
WS HTTPS  : 443, 53, 2095
DROPBEAR  : 109
UDPGW     : 7300
UDP CUSTOM: 1-65535
==================================
Payload:
GET / HTTP/1.1[crlf]Host: [host][crlf]Upgrade: websocket[crlf][crlf]
==================================
"
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEKS&parse_mode=html" $URL >/dev/null
clear
echo "$TEKS"
