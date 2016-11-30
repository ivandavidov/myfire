#!/bin/bash

if [ ! "$(id -u)" = "0" ] ; then
  echo "You need root permissions."
  exit 1
fi

if [ "$1" = "" ] ; then
  echo "You need to provide IP set as parameter."
  exit 1
fi
 
ipt=/sbin/iptables
ips=/sbin/ipset
sname=$1
input="$(echo $1).db"
tname="$(echo $sname)_tmp"

cd /var/lib/myfire

if [ ! -e $input ] ; then
  echo "$(date) - Database file '/var/lib/myfire/$input' does not exist. Cannot continue." | tee -a /var/log/myfire.log
  exit 1
fi

echo "$(date) - Create temporary ipset '$tname'." | tee -a /var/log/myfire.log
$ips create $tname hash:ip timeout 0 

echo "$(date) - Appending IPs to temporary ipset '$tname'. This can take a while..." | tee -a /var/log/myfire.log
for ip in `cat $input`
do
  $ips add $tname $ip
done

echo "$(date) - Fill new ipset '$sname' with IPs." | tee -a /var/log/myfire.log
$ips flush $sname
$ips swap $tname $sname

echo "$(date) - Delete temporary ipset '$tname'." | tee -a /var/log/myfire.log
$ips flush $tname
$ips destroy $tname

echo "$(date) - Done." | tee -a /var/log/myfire.log
exit 0

