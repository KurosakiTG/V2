#!/bin/bash
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
clear

dell() {
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/funny/.l2tp")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	echo ""
	echo " Select the existing client you want to remove"
	echo " Press CTRL+C to return"
	echo " ==============================="
	echo "     No  Expired   User"
	grep -E "^### " "/etc/funny/.l2tp" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select One Client[1]: " CLIENT_NUMBER
		else
			read -rp "Select One Client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
VPN_USER=$(grep -E "^### " "/etc/funny/.l2tp" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/funny/.l2tp" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
sed -i '/^"'"$VPN_USER"'" l2tpd/d' /etc/ppp/chap-secrets
sed -i '/^'"$VPN_USER"':\$1\$/d' /etc/ipsec.d/passwd
sed -i "/^### $VPN_USER $exp/d" /etc/funny/.l2tp
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
clear
echo ""
echo "=========================="
echo "   L2TP Account Deleted   "
echo "=========================="
echo "Username  : $VPN_USER"
echo "Expired   : $exp"
echo "=========================="
echo ""
}

renn() {
clear
NUMBER_OF_CLIENTS=$(grep -c -E "^### " "/etc/funny/.l2tp")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		clear
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	clear
	echo ""
	echo "Select the existing client you want to renew"
	echo " Press CTRL+C to return"
	echo -e "==============================="
	grep -E "^### " "/etc/funny/.l2tp" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
read -p "Expired (Days) : " masaaktif
user=$(grep -E "^### " "/etc/funny/.l2tp" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### " "/etc/funny/.l2tp" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "s/### $user $exp/### $user $exp4/g" /etc/funny/.l2tp
clear
echo ""
echo "=========================="
echo "   L2TP Account Renewed   "
echo "=========================="
echo "Username  : $user"
echo "Expired   : $exp4"
echo "=========================="
echo ""
}

mla() {
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "     =[ Member L2TPD Account ]=         "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
#echo -n > /var/log/xray/accsess.log
data=( `cat /etc/funny/.l2tp | grep '###' | cut -d ' ' -f 2 | sort | uniq`);
for user in "${data[@]}"
do
echo > /dev/null
jum=$(cat /etc/funny/.l2tp | grep -c '###' | awk '{print $1/2}')
if [[ $jum -gt 0 ]]; then
exp=$(grep -wE "^### $user" "/etc/funny/.l2tp" | cut -d ' ' -f 3 | sort | uniq)
echo -e "\e[33;1mUser\e[32;1m  : $user / $exp "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo "slot" >> /root/.system
else
echo > /dev/null
fi
sleep 0.1
done
aktif=$(cat /root/.system | wc -l)
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"        
echo -e "$aktif Member Active"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sed -i "d" /root/.system
}

mn1() {
clear
echo -e "
===========================================
[ 菜单 L2TP/IPsec PSK 面板 服务器上的 VPN ]
===========================================

1. Create Account L2TP
2. Delete Account L2TP
3. Renew  Account L2TP
4. List Total Mwmber Active L2TP
===========================================
   Press CTRL + C or X / x To exit Menu
"
read -p "Input Option: " apws
case $apws in
1) add-l2tp ;;
2) dell ;;
3) renn ;;
4) mla ;;
x|X) exit ;;
*) clear ; mn1 ;;
esac
}

opw_ares() {
mn1
}

misterrannn() {
opw_ares
}

19sko1kso1kzowjosn2osjwoxnowjdo() {
misterrannn
}

19sko1kso1kzowjosn2osjwoxnowjdo
