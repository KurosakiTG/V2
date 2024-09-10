#!/bin/bash
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
cert() {
clear
echo start
clear
domain=$(cat /etc/xray/domain)
clear
echo "
L FN 项目更新证书
=================================
Your Domain: $domain
=================================
4 For IPv4 &  For IPv6
"
echo -e "Generate new Ceritificate Please Input Type Your VPS"
read -p "Input Your Type Pointing ( 4 / 6 ): " ip_version
if [[ $ip_version == "4" ]]; then
    systemctl stop nginx
    mkdir /root/.acme.sh
    curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
    chmod +x /root/.acme.sh/acme.sh
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
    ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    systemctl start nginx
    echo "Cert installed for IPv4."
elif [[ $ip_version == "6" ]]; then
    systemctl stop nginx
    mkdir /root/.acme.sh
    curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
    chmod +x /root/.acme.sh/acme.sh
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256 --listen-v6
    ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    systemctl start nginx
    echo "Cert installed for IPv6."
else
    echo "Invalid IP version. Please choose '4' for IPv4 or '6' for IPv6."
    sleep 3
    cert
fi
}

dm() {
clear
echo -e "\e[33m===================================\033[0m"
echo -e "Domain anda saat ini:"
echo -e "$(cat /etc/xray/domain)"
echo ""
read -rp "Domain/Host: " -e host
echo ""
if [ -z $host ]; then
echo "DONE CHANGE DOMAIN"
echo -e "\e[33m===================================\033[0m"
read -n 1 -s -r -p "Press any key to back on menu"
menu
else
echo "$host" > /etc/xray/domain
echo -e "\e[33m===================================\033[0m"
echo -e ""
read -n 1 -s -r -p "Press any key to renew cert"
cert
fi
}

auto() {
     IP=$(curl 2ip.io)
     nama_depan=$(tr </dev/urandom -dc a-z0-9 | head -c7)
     DOMAIN="slowdns.cfd"
     dns=${nama_depan}.${DOMAIN}
     CF_ID=nurslamet522@gmail.com
     CF_KEY=3aff5edd5793fb57d682d4767a70b4056515b
     set -euo pipefail
     echo "Updating DNS for ${dns}..."
     ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
     RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${dns}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${dns}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

      RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${dns}'","content":"'${IP}'","ttl":120,"proxied":false}')
     clear
     rm -fr /etc/xray/domain
     echo "${dns}" > /etc/xray/domain
     cert
     }

dm1() {
clear
echo -e "
=================================
[ 菜单子域指向服务器 Cloudflare ]
=================================

1. Use Your Domain
2. Auto Pointing ( VPS IPv4 Only )
3. Renew Certificate ( VPS IPv6 & IPv4 )
=================================
     Press CTRL + C to Exit
"
read -p "Input Option: " apw
case $apw in
1) clear ; dm ;;
2) clear ; auto ;;
3) clear ; cert ;;
*) dm1 ;;
esac
}

dm1
