#!/bin/bash

if [ ! "$(id -u)" = "0" ] ; then
  echo "You need root permissions."
  exit 1
fi

if [ "$1" = "" ] ; then
  echo "You need to provide IP set as parameter."
  exit 1
fi

args="$@"

if [ "$args" = "" ] ; then
  cmd="$0"
else
  cmd="$0 $args"
fi

echo "$(date) - *** '$cmd' BEGIN ***" | tee -a /var/log/myfire.log
 
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

numips=$(cat $input | wc -l)

echo "$(date) - Appending $numips IPs to temporary ipset '$tname'. This can take a while..." | tee -a /var/log/myfire.log
for ip in $(cat $input)
do
  $ips add $tname $ip
done

echo "$(date) - Fill new ipset '$sname' with $numips IPs." | tee -a /var/log/myfire.log
$ips flush $sname
$ips swap $tname $sname

echo "$(date) - Delete temporary ipset '$tname'." | tee -a /var/log/myfire.log
$ips flush $tname
$ips destroy $tname

echo "$(date) - *** '$cmd' END ***" | tee -a /var/log/myfire.log
