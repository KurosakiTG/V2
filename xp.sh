#!/bin/bash
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
echo -n > /var/log/xray/access.log
clear

##----- Auto Remove Vmess
data=( `cat /etc/xray/config.json | grep '^###' | cut -d ' ' -f 2 | sort | uniq`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -le "0" ]]; then
sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json
sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json
rm -rf /var/www/html/$user
rm -rf /etc/funny/limit/xray/quota/$user
rm -rf /etc/funny/limit/xray/ip/$user
clear
fi
done


##------ Auto Remove SSH
hariini=`date +%d-%m-%Y`
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
totalaccounts=`cat /tmp/expirelist.txt | wc -l`
for((i=1; i<=$totalaccounts; i++ ))
do
tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
username=`echo $tuserval | cut -f1 -d:`
userexp=`echo $tuserval | cut -f2 -d:`
userexpireinseconds=$(( $userexp * 86400 ))
tglexp=`date -d @$userexpireinseconds`             
tgl=`echo $tglexp |awk -F" " '{print $3}'`
while [ ${#tgl} -lt 2 ]
do
tgl="0"$tgl
done
while [ ${#username} -lt 15 ]
do
username=$username" " 
done
bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
todaystime=`date +%s`
if [ $userexpireinseconds -ge $todaystime ] ;
then
:
else
userdel --force $username
rm -rf /etc/funny/limit/ssh/ip/$user
clear
fi
done

data=( `cat /etc/funny/.noob | grep '^###' | cut -d ' ' -f 2 | sort | uniq`); # // Membaca Akun Yang Active
now=`date +"%Y-%m-%d"` # // Tahun-Bulan-Tanggal hari inj
for user in "${data[@]}" # // Mendefinisikan Bahwa user = data
do
exp=$(grep -w "^### $user" "/etc/funny/.noob" | cut -d ' ' -f 3 | sort | uniq) # // Membaca Masa Aktif Username
d1=$(date -d "$exp" +%s) # // Menampikan Masa Aktif Sesuai Username
d2=$(date -d "$now" +%s) # // Tanggal Hari ini
exp2=$(( (d1 - d2) / 86400 )) # Xp 2
if [[ "$exp2" -le "0" ]]; then
sed -i "/^### $user $exp/,/^},{/d" /etc/funny/.noob
noobzvpns --remove-user "$user"
telegram-send --pre "
Detail Account NoobZVPN Exp
=========================
Username: $user
Tanggal Exp: $exp
========================="
fi
done

data=( `cat /etc/funny/.l2tp | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/etc/funny/.l2tp" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/d" "/var/lib/akbarstorevp/data-user-l2tp"
sed -i '/^"'"$user"'" l2tpd/d' /etc/ppp/chap-secrets
sed -i '/^'"$user"':\$1\$/d' /etc/ipsec.d/passwd
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
fi
done

systemctl daemon-reload
systemctl restart ssh xray noobzvpns wg-quick@wgcf wg-quick@wg0 xl2tpd ipsec