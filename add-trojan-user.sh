#!/bin/bash
domain=$(cat /etc/xray/domain)
clear
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
read -rp "User: " -e user
user_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)
if [[ ${user_EXISTS} == '1' ]]; then
clear
echo -e "${BB}========================================================${NC}"
echo -e "                  ${WB}Add Trojan Account${NC}                "
echo -e "${BB}========================================================${NC}"
echo -e "${YB}A client with the specified name was already created, please choose another name.${NC}"
echo -e "${BB}========================================================${NC}"
exit 0;
fi
done
clear
quota="1000"
#QUOTA
if [[ $quota -gt 0 ]]; then
echo -e "$[$quota * 1024 * 1024 * 1024]" > /etc/funny/limit/xray/quota/$user
else
echo > /dev/null
fi
iplimit="2"
#IPLIMIT
if [[ $iplimit -gt 0 ]]; then
echo -e "$iplimit" > /etc/funny/limit/xray/ip/$user
else
echo > /dev/null
fi
masaaktif="30"
uuid=$(cat /proc/sys/kernel/random/uuid)
exp=`date -d "$masaaktif days" +"%y-%m-%d"`
sed -i '/#trojan$/a\### '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user""'"' /etc/xray/config.json
trojanlink="trojan://${uuid}@${domain}:443?path=%2ftrojanws&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
trojanlink2="trojan://${uuid}@${domain}:443?mode=gun&security=tls&type=grpc&servicename=trojan-grpc&sni=${domain}#${user}"
systemctl daemon-reload ; systemctl restart xray > /dev/null 2>&1
clear
echo -e "=================================="
echo -e " TROJAN ACCOUNT >< RERECHAN STORE "
echo -e "=================================="
echo -e "Remarks   : ${user}"
echo -e "Host/IP   : ${domain}"
echo -e "port      : 443, 2095, 53"
echo -e "Key       : ${uuid}"
echo -e "Path      : /trojanws, /dinda"
echo -e "ServName  : trojan-grpc"
echo -e "=================================="
echo -e "WS TLS    : ${trojanlink}"
echo -e "=================================="
echo -e "Link GRPC : ${trojanlink2}"
echo -e "=================================="
