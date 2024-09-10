#!/bin/bash
#
#  |==========================================================|
#  • Autoscript AIO Lite Menu By Rerechan02
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @xlordeuyy
#  • Copyright 2024 18 Marc Indonesia [ Kebumen ]
#  |==========================================================|
#

# [ New Copyright ]
#
#  |=================================================================================|
#  • Autoscript AIO Lite Menu By FN Project                                          |
#  • FN Project Developer @Rerechan02 | @PR_Aiman | @farell_aditya_ardian            |
#  • Copyright 2024 10 Mei Indonesia [ Kebumen ] | [ Johor ] | [ 上海，中国 ]       |
#  |=================================================================================|
#
rest() {
clear
echo "This Feature Can Only Be Used According To Vps Data With This Autoscript"
echo "Please input link to your vps data backup file."
read -rp "Link File: " -e url
cd /root
wget -O backup.zip "$url"
unzip backup.zip
rm -f backup.zip
sleep 1
echo "Tengah Melakukan Backup Data"
cd /root/backup
cp passwd /etc/
cp group /etc/
cp shadow /etc/
cp gshadow /etc/
cp -r xray /etc/
cp -r funny /etc/
cp -r noobzvpns /etc/
cp -r wireguard /etc/
cp chap-secrets /etc/ppp/
cp passwd1 /etc/ipsec.d/passwd
clear
cd
rm -rf /root/backup
rm -f backup.zip
clear
echo "Telah Berjaya Melakukan Backup"
}

restf() {
cd /root
file="backup.zip"
if [ -f "$file" ]; then
echo "$file ditemukan, melanjutkan proses..."
sleep 2
clear
unzip backup.zip
rm -f backup.zip
sleep 1
echo "Tengah Melakukan Backup Data"
cd /root/backup
cp passwd /etc/
cp group /etc/
cp shadow /etc/
cp gshadow /etc/
cp -r xray /etc/
cp -r funny /etc/
cp -r noobzvpns /etc/
cp -r wireguard /etc/
cp chap-secrets /etc/ppp/
cp passwd1 /etc/ipsec.d/passwd
clear
cd
rm -rf /root/backup
rm -f backup.zip
clear
echo "Telah Berjaya Melakukan Backup"
else
    echo "Error: File $file Not Found"
fi
}

clear

bmenu() {
clear
echo "
============================
Menu Backup Data VPN in VpS
============================

1. Backup Your Data VPN
2. Restore With Link Backup
3. Restore With SFTP / Termius
4. Bot Notification Setup on Server
==============================
Press CTRL + C / X to Exit Menu
"
read -p "Input Valid Number Option: " mla
case $mla in
1) clear ; backup ;;
2) clear ; rest ;;
3) clear ; restf ;;
4) botmenu ;;
x) exit ;;
*) echo " Please Input Valid Number " ; bmenu ;;
esac
}

bmenu
