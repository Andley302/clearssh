#!/bin/bash
#INSTALADOR DEPENDENCIAS ONEVPS
clear;
echo "ClearSSH - Iniciando instalação...";
sleep 5;
clear;
apt install screen iptables cron certbot git screen htop net-tools nload speedtest-cli ipset -y;
apt install dos2unix -y && apt install unzip && wget https://raw.githubusercontent.com/Andley302/clearssh/main/sync/sync.zip && unzip sync.zip && chmod +x *.sh && dos2unix *.sh && rm -rf sync.zip;
clear;
echo "Instalando DKMS (Anti-torrent)...";
apt purge xtables* -y;
apt install make -y;
apt install dkms -y;
apt install linux-headers-$(uname -r);
cd /root;
wget https://raw.githubusercontent.com/Andley302/clearssh/main/iptables/xtables-addons-common_3.18-1_amd64.deb;
wget https://raw.githubusercontent.com/Andley302/clearssh/main/iptables/xtables-addons-dkms_3.18-1_all.deb;
dpkg -i *.deb;
apt --fix-broken install;
rm -rf *.deb;
clear;
echo "Banner SSH...";
sleep 5
cd /etc;
wget https://raw.githubusercontent.com/Andley302/clearssh/main/ssh/bannerssh;
cd /root;
clear;
echo "Instalando Dropbear...";
sleep 5;
porta=8080;
apt install dropbear -y;
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear >/dev/null 2>&1
sed -i "s/DROPBEAR_PORT=22/DROPBEAR_PORT=$porta/g" /etc/default/dropbear >/dev/null 2>&1
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 8000 -p 7777"/g' /etc/default/dropbear >/dev/null 2>&1
sed -i 's/DROPBEAR_BANNER=""//g' /etc/default/dropbear >/dev/null 2>&1
sed -i "$ a DROPBEAR_BANNER=\"/etc/bannerssh\"" /etc/default/dropbear;
grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config >/tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >>/etc/ssh/sshd_config
grep -v "^PermitTunnel yes" /etc/ssh/sshd_config >/tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
echo "PermitTunnel yes" >>/etc/ssh/sshd_config
echo "/bin/false" >>/etc/shells
service dropbear restart;
clear;
echo "Instalando stunnel4...";
sleep 5;
apt install stunnel4 -y;
cd /etc/stunnel;
rm -rf stunnel.conf;
wget https://raw.githubusercontent.com/Andley302/clearssh/main/stunnel/stunnel.conf;
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
clear;
echo "Verificando certificados stunnel...";
sleep 5;
if [ -e cert.pem ]
then
    echo "Certificado já está instalado. Continuando...."
else
    echo "Baixando certificados..."
    wget https://raw.githubusercontent.com/Andley302/clearssh/main/stunnel/cert.pem
	wget https://raw.githubusercontent.com/Andley302/clearssh/main/stunnel/key.pem
fi
service stunnel4 restart;
clear;
echo "API Onlines (Apache2)...";
sleep 5;
apt install apache2 -y;
cd /etc/apache2 && rm -rf ports.conf;
wget https://raw.githubusercontent.com/Andley302/clearssh/main/onlines-api/ports.conf;
service apache2 restart;
mkdir /var/www/html/server;
clear;
echo "Regras iptables...";
sleep 5;
cd /root && wget https://raw.githubusercontent.com/Andley302/clearssh/main/onlines-api/onlines && chmod +x onlines && mv onlines /bin/onlines;
cd /root && wget https://raw.githubusercontent.com/Andley302/clearssh/main/onlines-api/onlineapp.sh && chmod +x onlineapp.sh && ./onlineapp.sh;
cd /root && rm -rf iptables* && wget https://raw.githubusercontent.com/Andley302/clearssh/main/iptables/iptables_reset_53 && mv iptables_reset_53 iptables.sh && chmod +x iptables.sh && ./iptables.sh;

##BAIXA E COMPILA DNSTT
clear;
echo "Preparando DNSTT...";
sleep 5;
cd /usr/local;
wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz;
tar xvf go1.16.2.linux-amd64.tar.gz;
export GOROOT=/usr/local/go;
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH;
cd /root;
git clone https://www.bamsoftware.com/git/dnstt.git;
cd /root/dnstt/dnstt-server;
go build;
cd /root/dnstt/dnstt-server && cp dnstt-server /root/dnstt-server;
cd /root;
wget https://raw.githubusercontent.com/Andley302/clearssh/main/dnstt/server.key;
wget https://raw.githubusercontent.com/Andley302/clearssh/main/dnstt/server.pub;
##
##ENABLE RC.LOCAL
set_ns () {
cd /etc;
mv rc.local rc.local.bkp;
wget https://raw.githubusercontent.com/Andley302/clearssh/main/others/rc.local;
wget https://raw.githubusercontent.com/Andley302/clearssh/main/others/restartdns.sh;
chmod +x /etc/rc.local;
echo -ne "\033[1;32m INFORME SEU NS (NAMESERVER)\033[1;37m: "; read nameserver
sed -i "s;1234;$nameserver;g" /etc/rc.local > /dev/null 2>&1
sed -i "s;1234;$nameserver;g" restartdns.sh > /dev/null 2>&1
systemctl enable rc-local;
systemctl start rc-local;
chmod +x restartdns.sh
mv restartdns.sh /bin/restartdns
}
clear;
echo "Aguarde...";
sleep 5;
echo "Deseja instalar o DNSTT? (s/n)"
read CONFIRMA

case $CONFIRMA in 
    "s")
        set_ns
    ;;

    "n")
                 
    ;;

    *)
        echo  "Opção inválida."
    ;;
esac
#LIMITADOR DE PROCESSOS
clear;
echo "Aumentando limite de processos do sistema...";
sleep 5;
cd /etc/security;
mv limits.conf limits.conf.bak;
wget https://raw.githubusercontent.com/Andley302/clearssh/main/others/limits.conf && chmod +x limits.conf;
#CRONTAB
echo "Configurando crontab...";
sleep 5;
cd /etc;
wget https://raw.githubusercontent.com/Andley302/clearssh/main/others/autostart;
chmod +x autostart;
crontab -r >/dev/null 2>&1
(
	crontab -l 2>/dev/null
	echo "@reboot /etc/autostart"
	echo "* * * * * /etc/autostart"
	echo "*/1 * * * * /root/onlineapp.sh"
	echo "* * * * * /root/restartdrop.sh"
) | crontab -
service cron reload;
clear;
echo "Instalando fast...";
cd /root
sleep 5;
wget https://github.com/ddo/fast/releases/download/v0.0.4/fast_linux_amd64;
sudo install fast_linux_amd64 /usr/local/bin/fast;
clear;
echo "Aguarde...";
sleep 5;
echo "Deseja instalar o proxy node (1), python (2) ou go (3)? (1,2 ou 3)"
read CONFIRMA

case $CONFIRMA in 
    "1")
     #NODE
    clear;
    echo "Instalando NodeJS...";
    sleep 5; 
    cd ~
    curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
    sudo bash nodesource_setup.sh
    sudo apt install nodejs -y;
    cd /root;
    clear;
    echo "Instalando Proxy...";
    sleep 5;
    wget https://raw.githubusercontent.com/Andley302/clearssh/main/wsproxy/proxy3.js;
    clear;
    echo -e "netstat -tlpn | grep -w 80 > /dev/null || screen -dmS nodews node /root/proxy3.js" >> /etc/autostart;
    netstat -tlpn | grep -w 80 > /dev/null || screen -dmS nodews node /root/proxy3.js
    ;;

    "2")
    #python
    cd /root;
    clear;
    echo "Instalando Python...";
    sleep 5; 
    apt install python python3 -y;
    clear;
    wget https://raw.githubusercontent.com/Andley302/clearssh/main/wsproxy/wsproxy.py
    wget https://raw.githubusercontent.com/Andley302/clearssh/main/wsproxy/antcrashws.sh -O /bin/antcrashws.sh > /dev/null 2>&1
    chmod +x /bin/antcrashws.sh;
    echo -e "netstat -tlpn | grep -w 80 > /dev/null || screen -dmS wsproxy80 antcrashws.sh 80" >> /etc/autostart;
    netstat -tlpn | grep -w 80 > /dev/null || screen -dmS wsproxy80 antcrashws.sh 80
                 
    ;;
    "3")
    #proxygo
    cd /root;
    clear;
    echo "Instalando Proxy Go...";
    sleep 5; 
    clear;
    wget https://raw.githubusercontent.com/Andley302/clearssh/main/wsproxy/sshProxy -O /bin/sshProxy > /dev/null 2>&1
    chmod +x /bin/sshProxy;
    echo -e "netstat -tlpn | grep -w 80 > /dev/null || screen -dmS sshProxy -addr :80 -dstAddr 127.0.0.1:8080" >> /etc/autostart;
    netstat -tlpn | grep -w 80 > /dev/null || screen -dmS sshProxy -addr :80 -dstAddr 127.0.0.1:8080
                 
    ;;

    *)
        echo  "Opção inválida."
    ;;
esac
#BADVPN
clear;
echo "Aguarde...";
sleep 5;
clear;
echo "Deseja instalar o badvpn? (s/n)"
read CONFIRMA

case $CONFIRMA in 
    "s")
        cd /root && wget https://raw.githubusercontent.com/Andley302/clearssh/main/badvpn/badvpn-x.sh && chmod +x badvpn-x.sh && ./badvpn-x.sh;
    ;;

    "n")
                 
    ;;

    *)
        echo  "Opção inválida."
    ;;
esac
##FIM
cd /root;
clear;
echo "Reiniciando DNSTT (Caso tenha sido instalado)...";
sleep 5;
restartdns;
clear;
echo "Ferramentas de otimização....";
sleep 5;
cd /root && wget https://raw.githubusercontent.com/Andley302/clearssh/main/others/consumo && chmod +x consumo && mv consumo /bin/consumo;
apt autoremove -y && apt -f install -y && apt autoclean -y;
clear;
echo "Finalizando...";
sleep 5;
service dropbear stop;
service dropbear start;
rm -rf installer.sh;
rm -rf fast_linux_amd64;
clear;
echo "FIM!";
sleep 5;
