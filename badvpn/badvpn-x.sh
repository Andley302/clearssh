#!/bin/bash
clear;
cd /bin;
rm -rf antcrashudp.sh;
rm -rf badvpn-udpgw;
echo "INSTALADOR BADVPN X BY @sisudragon";
sleep 5;
clear;
wget https://raw.githubusercontent.com/Andley302/clearssh/main/badvpn/badvpnx-files/antcrashudp.sh -O /bin/antcrashudp.sh > /dev/null 2>&1
chmod +x /bin/antcrashudp.sh;
wget https://raw.githubusercontent.com/Andley302/clearssh/main/badvpn/badvpnx-files/badvpn-udpgw -O /bin/badvpn-udpgw > /dev/null 2>&1
chmod +x /bin/badvpn-udpgw;
clear;
echo "INSTALANDO...";
sleep 5;
echo -e "ps x | grep 'udpvpn' | grep -v 'grep' || screen -dmS udpvpn antcrashudp.sh" >>/etc/autostart;
ps x | grep 'udpvpn' | grep -v 'grep' || screen -dmS udpvpn antcrashudp.sh;
clear;
echo "BADVPN X INSTALADO COM SUCESSO!";

