#!/bin/bash
#INSTALADOR DEPENDENCIAS ONEVPS
apt-get update -y && apt-get upgrade -y;
apt install screen iptables cron git screen htop nload speedtest-cli ipset -y;
apt update && apt upgrade -y && apt install dos2unix -y && apt install unzip && wget https://raw.githubusercontent.com/Andley302/utils/main/sync.zip && unzip sync.zip && chmod +x *.sh && dos2unix *.sh && rm -rf sync.zip;
apt purge xtables* -y;
apt install make -y;
apt install dkms -y;
apt install linux-headers-$(uname -r);
cd /root;
wget https://raw.githubusercontent.com/Andley302/utils/main/packages/xtables-addons-common_3.18-1_amd64.deb;
wget https://raw.githubusercontent.com/Andley302/utils/main/packages/xtables-addons-dkms_3.18-1_all.deb;
dpkg -i *.deb;
apt --fix-broken install;
rm -rf *.deb;
cd /etc;
wget https://raw.githubusercontent.com/Andley302/utils/main/bannerssh;
cd /root;
porta=8080;
apt install dropbear -y;
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear >/dev/null 2>&1
sed -i "s/DROPBEAR_PORT=22/DROPBEAR_PORT=$porta/g" /etc/default/dropbear >/dev/null 2>&1
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 8000"/g' /etc/default/dropbear >/dev/null 2>&1
sed -i 's/DROPBEAR_BANNER=""//g' /etc/default/dropbear >/dev/null 2>&1
sed -i "$ a DROPBEAR_BANNER=\"/etc/bannerssh\"" /etc/default/dropbear;
grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config >/tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >>/etc/ssh/sshd_config
grep -v "^PermitTunnel yes" /etc/ssh/sshd_config >/tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
echo "PermitTunnel yes" >>/etc/ssh/sshd_config
echo "/bin/false" >>/etc/shells
service dropbear restart;
apt install stunnel4 -y;
cd /etc/stunnel;
rm -rf stunnel.conf;
wget https://raw.githubusercontent.com/Andley302/utils/main/stunnel.conf;
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
if [ -e cert.pem ]
then
    echo "ok"
else
    wget 
fi
service stunnel4 restart;
apt install apache2 -y;
cd /etc/apache2 && rm -rf ports.conf;
wget https://raw.githubusercontent.com/Andley302/utils/main/ports.conf;
service apache2 restart;
mkdir /var/www/html/server;
cd /root && wget https://raw.githubusercontent.com/Andley302/utils/main/onlineapp.sh && chmod +x onlineapp.sh && ./onlineapp.sh;
cd /root && rm -rf iptables* && wget https://raw.githubusercontent.com/Andley302/utils/main/iptables_reset_53 && mv iptables_reset_53 iptables.sh && chmod +x iptables.sh && ./iptables.sh;

##BAIXA E COMPILA DNSTT
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
wget https://raw.githubusercontent.com/Andley302/utils/main/dnstt-keys/server.key;
wget https://raw.githubusercontent.com/Andley302/utils/main/dnstt-keys/server.pub;
##
##ENABLE RC.LOCAL
set_ns () {
cd /etc;
mv rc.local rc.local.bkp;
wget https://raw.githubusercontent.com/Andley302/utils/main/rc.local;
wget https://raw.githubusercontent.com/Andley302/utils/main/restartdns.sh;
chmod +x /etc/rc.local;
echo -ne "\033[1;32m INFORME SEU NS (NAMESERVER)\033[1;37m: "; read nameserver
sed -i "s;1234;$nameserver;g" /etc/rc.local > /dev/null 2>&1
sed -i "s;1234;$nameserver;g" restartdns.sh > /dev/null 2>&1
systemctl enable rc-local;
systemctl start rc-local;
chmod +x restartdns.sh
mv restartdns.sh /bin/restartdns
}
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
cd /etc/security;
mv limits.conf limits.conf.bak;
wget https://raw.githubusercontent.com/Andley302/utils/main/limits.conf && chmod +x limits.conf;
cd /root;
clear;
clear;
echo "INSTALANDO FAST";
wget https://github.com/ddo/fast/releases/download/v0.0.4/fast_linux_amd64;
sudo install fast_linux_amd64 /usr/local/bin/fast;
cd /root;
##FIM
clear;
echo "Fim!";
sleep 5;
