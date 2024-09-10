#!/bin/bash
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
domain=$(cat /etc/xray/domain)
clear
until [[ $user =~ ^[a-za-z0-9_]+$ && ${client_exists} == '0' ]]; do
echo -e "
=========================
[ 创建 Shadowsocks 帐户 ]
=========================
"
read -p "Username: " user
client_exists=$(grep -w $user /etc/xray/config.json | wc -l)
if [[ ${client_exists} == '1' ]]; then
clear
echo -e "
Already Exist Name
"
fi
done
read -p "Active Time: " masaaktif
exp=`date -d "$masaaktif days" +"%y-%m-%d"`
uuid=$(xray uuid)
sed -i '/#ssws$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","method": "'""aes-128-gcm""'","email": "'""$user""'"' /etc/xray/config.json
echo -n "aes-128-gcm:$uuid" | base64 -w 0 > /tmp/log
ss_base64=$(cat /tmp/log)
#link1="ss://${ss_base64}@$domain:443?path=/ssws&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
#link2="ss://${ss_base64}@$domain:80?path=/ssws&security=none&host=${domain}&type=ws#${user}"
link1="ss://${ss_base64}@${domain}:443?path=/ssws&security=tls&encryption=none&type=ws#${user}"
link2="ss://${ss_base64}@${domain}:80?path=/ssws&security=none&encryption=none&type=ws#${user}"

rm -fr /tmp/log
clear
systemctl daemon-reload ; systemctl restart xray
clear
TEKS="
========================
[ Shadowsocks 帐户信息 ]
========================

Hostname: $domain
WildCard: bug.com.${domain}
Username: $user
Password: $uuid
Expired : $exp
========================
chiper  : aes-128-gcm
Network : WebSocket
Path    : /ssws
Port    : 443
Alpn    : http/1.1
========================
Link TLS    : $link1
========================
Link NonTLS : $link2
========================
"
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEKS&parse_mode=html" $URL >/dev/null
clear
echo "$TEKS"