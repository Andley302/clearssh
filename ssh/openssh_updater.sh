#!/bin/bash
clear;
sleep 5;
echo "Atualizar OpenSSH...";
cd /root;
mkdir /var/lib/sshd
chmod -R 700 /var/lib/sshd/
chown -R root:sys /var/lib/sshd/
useradd -r -U -d /var/lib/sshd/ -c "sshd privsep" -s /bin/false sshd
apt install libpam0g-dev libselinux1-dev build-essential zlib1g-dev libssl-dev -y ;
wget https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.0p1.tar.gz;
tar -xzf *.tar.gz;
cd  openssh-9.0p1;
./configure --with-md5-passwords --with-pam --with-selinux --with-privsep-path=/var/lib/sshd/ --sysconfdir=/etc/ssh ;
make;
make install;
clear;
sleep 5;
echo "Finalizando...";
sudo cd /usr/sbin;
sudo mv sshd sshd.bak;
sudo cp /usr/local/sbin/sshd sshd;
clear;
sleep 5;
echo "Reiniciando servidor ...";
sleep 5;
reboot;
