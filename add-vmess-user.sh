#!/bin/bash
iplimit="2"
quota="100"
masaaktif="30"
domain=$(cat /etc/xray/domain)
clear
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do

                read -rp "User: " -e user
                CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

                if [[ ${CLIENT_EXISTS} -gt "0" ]]; then
clear
                        echo ""
                        echo "A client with the specified name was already created, please choose another name."
                        echo ""

                        exit 0;
                fi
        done
#QUOTA
if [[ $quota -gt 0 ]]; then
echo -e "$[$quota * 1024 * 1024 * 1024]" > /etc/funny/limit/xray/quota/$user
else
echo > /dev/null
fi

#IPLIMIT
if [[ $iplimit -gt 0 ]]; then
echo -e "$iplimit" > /etc/funny/limit/xray/ip/$user
else
echo > /dev/null
fi
clear
uuid=$(cat /proc/sys/kernel/random/uuid)
exp=`date -d "$masaaktif days" +"%y-%m-%d"`
sed -i '/#vmess$/a\### '"$user $exp"'\
},{"id": "'""$uuid""'","alterid": '"0"',"email": "'""$user""'"' /etc/xray/config.json
clear
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
"path": "/vmessws",
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
vmesslink1="vmess://$(echo $acs | base64 -w 0)"
vmesslink2="vmess://$(echo $ask | base64 -w 0)"
vmesslink3="vmess://$(echo $grpc | base64 -w 0)"
systemctl daemon-reload ; systemctl restart xray > /dev/null 2>&1
clear
echo -e "==================================="
echo -e "     Xray/V2Ray/Vmess Account      "
echo -e "==================================="
echo -e "Remarks : ${user}"
echo -e "Domain : ${domain}"
echo -e "Port TLS : 53, 443, 2095"
echo -e "Port none TLS : 80, 2082"
echo -e "Port  GRPC : 443"
echo -e "id : ${uuid}"
echo -e "alterId : 0"
echo -e "Security : auto"
echo -e "Network : ws, httpupgrade"
echo -e "Path : /vmess, /vmessws, /worryfree, /kuota-habis, /love"
echo -e "ServiceName : vmess-grpc"
echo -e "==================================="
echo -e "Link TLS : ${vmesslink1}"
echo -e "==================================="
echo -e "Link non-TLS : ${vmesslink2}"
echo -e "==================================="
echo -e "Link GRPC : ${vmesslink3}"
echo -e "==================================="
echo ""
