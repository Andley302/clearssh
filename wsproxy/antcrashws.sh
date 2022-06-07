#!/bin/bash
port=$1
while true
do
#ulimit -c unlimited
#ulimit -d unlimited
#ulimit -e unlimited
#ulimit -f unlimited
#ulimit -i unlimited
#ulimit -l unlimited
#ulimit -m unlimited
#ulimit -n 999999
#ulimit -q unlimited
#ulimit -r unlimited
#ulimit -s unlimited
#ulimit -t unlimited
##ulimit -u unlimited
#ulimit -v unlimited
#ulimit -x unlimited
netstat -tlpn | grep -w 80 > /dev/null || python /root/wsproxy.py $port
sleep 1
done
