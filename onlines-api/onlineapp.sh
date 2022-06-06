#!/bin/bash
_ons=$(ps -x | grep sshd | grep -v root | grep priv | wc -l)
#[[ "$(cat /etc/CrashVPN/Exp)" != "" ]] && _expuser=$(cat /etc/CrashVPN/Exp) || _expuser="0"
[[ -e /etc/openvpn/openvpn-status.log ]] && _onop=$(grep -c "10" /etc/openvpn/openvpn-status.log) || _onop="0"
[[ -e /etc/default/dropbear ]] && _drp=$(ps aux | grep dropbear | grep -v grep | wc -l) _ondrp=$(($_drp - 1)) || _ondrp="0"
_onli=$(($_ons + $_onop + $_ondrp))
_onlin=$(printf '%-5s' "$_onli")

#PASSA ONLINE PRA VARIAVEL
CURRENT_ONLINES=$_onlin

#ESCREVE ARQUIVO
echo {"success": 1,"Server": [{"Onlines": \"$CURRENT_ONLINES\"}]}  > /var/www/html/server/online_app
echo $CURRENT_ONLINES  > /var/www/html/server/online
