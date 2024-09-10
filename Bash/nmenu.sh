#!/bin/bash

addn() {
domain=$(cat /etc/xray/domain)
clear
echo -e "
====================
Add Account NoobzVPN
===================="
read -p "Username  : " user
read -p "Password  : " pass
read -p "Masa Aktif: " masaaktif
clear
noobzvpns --add-user "$user" "$pass"
noobzvpns --expired-user "$username" "$masaaktif"
expi=`date -d "$masaaktif days" +"%Y-%m-%d"`
echo "### ${user} ${expi}" >>/etc/funny/.noob
clear
TEKS="
================
NoobzVPN Account
================
Hostname  : $domain
Username  : $user
Password  : $pass
================
TCP_STD/HTTP  : 8080
TCP_SSL/HTTPS : 9443
================
Expired   : $expi
================"
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEKS&parse_mode=html" $URL >/dev/null
clear
echo "$TEKS"
}

deln() {
mna=$(grep -e "^### " "/etc/funny/.noob" | cut -d ' ' -f 2-3 | column -t | sort | uniq)
clear
echo -e "
==============
Delete Account
==============
$mna
=============
"
read -p "Input Name: " name
if [ -z $name ]; then
menu
else
exp=$(grep -we "^### $user" "/etc/funny/.noob" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^### $user $exp/,/^},{/d" /etc/funny/.noob
noobzvpns --remove-user "$name"
clear
TEKS="
===============
Username Delete
===============

User: $name
Exp : $exp
===============
"
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEKS&parse_mode=html" $URL >/dev/null
clear
echo "$TEKS"
fi
}

list() {
clear
noobzvpns --info-all-user
}

tampilan() {
white='\e[037;1m'
clear
echo -e "${white}
=========================
[ <== NOOBZVPN MENJ ==> ]
=========================

1. Add Account
2. Delete Account
3. List Active Account
=========================
Preess CTRL or X to exit
=========================
"
read -p "Input Option: " inrere
case $inrere in
1|01) clear ; addn ;;
2|02) clear ; deln ;;
3|03) clear ; list ;;
x|X) exit ;;
*) echo "Wrong Number " ; tampilan ;;
esac
}
tampilan
