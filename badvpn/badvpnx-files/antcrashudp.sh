#!/bin/bash
while true
do
ulimit -c unlimited
ulimit -d unlimited
ulimit -e unlimited
ulimit -f unlimited
ulimit -i unlimited
ulimit -l unlimited
ulimit -m unlimited
ulimit -n 999999
ulimit -q unlimited
ulimit -r unlimited
ulimit -s unlimited
ulimit -t unlimited
ulimit -u unlimited
ulimit -v unlimited
ulimit -x unlimited
#badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 2048 --max-connections-for-client 2 --client-socket-sndbuf 10000
#badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 4096 --max-connections-for-client 2 --client-socket-sndbuf 10000
#badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 8192 --max-connections-for-client 2 --client-socket-sndbuf 10000
badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 16384 --max-connections-for-client 16384 --client-socket-sndbuf 10000
sleep 1
done
