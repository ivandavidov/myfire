#!/bin/sh

ipt="/sbin/iptables"
ips="/sbin/ipset"
eth="eth0"
ipsets=badips,torips,blackips,whiteips

if [ ! "$(id -u)" = "0" ] ; then
  echo "You need root permissions."
  exit 1
fi

args="$@"

if [ "$args" = "" ] ; then
  cmd="$0"
else
  cmd="$0 $args"
fi

echo "$(date) - *** '$cmd' BEGIN ***" | tee -a /var/log/myfire.log

# Failsafe - die if /sbin/iptables not found 
[ ! -x "$ipt" ] && { echo "$(date) - $0: \"${ipt}\" command not found." | tee -a /var/log/myfire.log; exit 1; }

## Failsafe - die if /sbin/ipset not found
[ ! -x "$ips" ] && { echo "$(date) - $0: \"${ips}\" command not found." | tee -a /var/log/myfire.log; exit 1; }

echo "$(date) - Stop firewall and allow everyone." | tee -a /var/log/myfire.log

$ips flush

$ipt -P INPUT ACCEPT
$ipt -P FORWARD ACCEPT
$ipt -P OUTPUT ACCEPT
$ipt -F
$ipt -X
$ipt -t nat -F
$ipt -t nat -X
$ipt -t mangle -F
$ipt -t mangle -X
$ipt -t raw -F 
$ipt -t raw -X

$ips destroy

echo "$(date) - Create default IP sets." | tee -a /var/log/myfire.log
$ips create torips hash:ip timeout 0
$ips create badips hash:ip timeout 0
$ips create blackips hash:ip timeout 0
$ips create whiteips hash:ip timeout 0

echo "$(date) - Add default firewall rules." | tee -a /var/log/myfire.log

$ipt -A INPUT -i lo -j ACCEPT
$ipt -A INPUT -i $eth -m state --state INVALID -j DROP
$ipt -A INPUT -i $eth -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$ipt -A INPUT -i $eth -m set --match-set whiteips src -j ACCEPT
$ipt -A INPUT -i $eth -m set --match-set torips src -j DROP
$ipt -A INPUT -i $eth -m set --match-set badips src -j DROP
$ipt -A INPUT -i $eth -m set --match-set blackips src -j DROP

# Put your own 'iptables' rules here. The default rule
# below allows SSH connections. You can copy/paste this
# rule and change the port from 22 to 80 in order to
# enable incoming HTTP traffic.
$ipt -A INPUT -i $eth -p tcp -m tcp --dport 22 -j ACCEPT

# In the end we put rule which discards all other traffic.
$ipt -A INPUT -i $eth -j DROP

echo "$(date) - Touch default database files." | tee -a /var/log/myfire.log

for i in $(echo $ipsets | sed "s/,/ /g")
do
  dbfile="/var/lib/myfire/$(echo $i).db"
  touch $dbfile
done

echo "$(date) - *** '$cmd' END ***" | tee -a /var/log/myfire.log

