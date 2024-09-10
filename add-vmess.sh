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
===================
[ 创建 Vmess 帐户 ]
===================
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
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterid": '"0"',"email": "'""$user""'"' /etc/xray/config.json
systemctl daemon-reload ; systemctl restart xray
acs=`cat<<eof
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "/vmessws",
"type": "none",
"host": "${domain}",
"tls": "tls"
}
eof`
ask=`cat<<eof
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "80",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "/worryfree",
"type": "none",
"host": "${domain}",
"tls": "none"
}
eof`
grpc=`cat<<eof
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "grpc",
"path": "vmess-grpc",
"type": "none",
"host": "${domain}",
"tls": "tls"
}
eof`
hts=`cat<<eof
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "80",
"id": "${uuid}",
"aid": "0",
"net": "httpupgrade",
"path": "/love-dinda",
"type": "httpupgrade",
"host": "${domain}",
"tls": "none"
}
eof`
cs=`cat<<eof
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "443",
"id": "${uuid}",
"aid": "0",
"net": "httpupgrade",
"path": "/love-dinda",
"type": "httpupgrade",
"host": "${domain}",
"tls": "tls"
}
eof`
bpjs=`cat<<eof
{
"v": "2",
"ps": "${user}",
"add": "${domain}",
"port": "8880",
"id": "${uuid}",
"aid": "0",
"net": "ws",
"path": "/whatever",
"type": "none",
"host": "${domain}",
"tls": "none"
}
eof`
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmess_base642=$( base64 -w 0 <<< $vmess_json2)
vmess_base643=$( base64 -w 0 <<< $vmess_json3)
vmesslink1="vmess://$(echo $acs | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"
vmesslink4="vmess://$(echo $hts | base64 -w 0)"
vmesslink5="vmess://$(echo $cs | base64 -w 0)"
vmesslink6="vmess://$(echo $bpjs | base64 -w 0)"
clear
TEKS="
=========================
[ 信息帐户 X 射线 Vmess ]
=========================

Remarks    : $user
Hostname   : $domain
WildCard   : bug.com.${domain}
UUID       : $uuid
Expired    : $exp
=========================
Port TLS   : 443, 53, 2095
Port HTTP  : 80, 2082
AlterID    : 0
Network    : ws, httpupgrade, gRPC
Alpn       : http/1.1
Path WS    : /vmess | /vmessws
Path HTTP  : /love  | /love-dinda
ServiceName: vmess-grpc
=========================
Multipath  : /custom | /whatever
Port       : 8880
Network    : WebSocket NonTLS
AlID, Alpn : 0, http/1.1
=========================
TLS        : $vmesslink1
=========================
NoneTLS    : $vmesslink2
=========================
HTTP None  : $vmesslink4
=========================
HTTP TLS   : $vmesslink5
=========================
MultiPath  : $vmesslink6
=========================
gRPC       : $vmesslink3
=========================
"
CHATID=$(cat /etc/funny/.chatid)
KEY=$(cat /etc/funny/.keybot)
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEKS&parse_mode=html" $URL >/dev/null
clear
echo "$TEKS"
