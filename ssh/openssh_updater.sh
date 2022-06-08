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
cd /usr/sbin/
mv sshd sshd.bak
cp /usr/local/sbin/sshd sshd
clear;
sleep 5;
echo "Reiniciando servidor ...";
sed -i "s/#PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
echo 'PasswordAuthentication yes' > /etc/ssh/sshd_config
sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config
sed -i "s/without-password/yes/g" /etc/ssh/sshd_config
sed -i "s/prohibit-password/yes/g" /etc/ssh/sshd_config

sleep 5;
reboot;
