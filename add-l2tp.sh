#!/bin/bash
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
IP=$(curl -s 2ip.io)
domain=$(cat /etc/xray/domain)
clear
until [[ $VPN_USER =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "Username : " -e VPN_USER
		CLIENT_EXISTS=$(grep -w $VPN_USER /etc/funny/.l2tp | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username Already On VPS Please Choose Another"
			exit 1
		fi
	done
read -p "Password : " VPN_PASSWORD
read -p "Expired (Days) : " masaaktif
hariini=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
clear
cat >> /etc/ppp/chap-secrets <<EOF
"$VPN_USER" l2tpd "$VPN_PASSWORD" *
EOF
VPN_PASSWORD_ENC=$(openssl passwd -1 "$VPN_PASSWORD")
cat >> /etc/ipsec.d/passwd <<EOF
$VPN_USER:$VPN_PASSWORD_ENC:xauth-psk
EOF
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
echo -e "### $VPN_USER $exp">>"/etc/funny/.l2tp"
systemctl restart xl2tpd
systemctl restart ipsec
TEKS="
L2TP PSK ACCOUNT
===================

Hostname: $domain / $IP
Username: $VPN_USER
Password: $VPN_PASSWORD
Key/Auth: myvpn
Expired : $exp
===================
"
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEKS&parse_mode=html" $URL >/dev/null
clear
echo "$TEKS"
