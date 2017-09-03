#!/bin/bash

ipt=/sbin/iptables
ips=/sbin/ipset
ipsets=badips,torips,blackips,whiteips

if [ ! "$(id -u)" = "0" ] ; then
  echo "You need root permissions."
  exit 1
fi

if [ "$1" = "" ] ; then
  echo "You need to provide IP address as parameter."
  exit 1
fi

args="$@"

if [ "$args" = "" ] ; then
  cmd="$0"
else
  cmd="$0 $args"
fi

echo "$(date) - *** '$cmd' BEGIN ***" | tee -a /var/log/myfire.log

ip=$1
ip_esc=$(echo ${ip//./\\.})

cd /var/lib/myfire

for i in $(echo $ipsets | sed "s/,/ /g")
do
  ip_found_in_set=$($ips list $i | grep $ip_esc)

  if [ ! "$ip_found_in_set" = "" ] ; then
    $ips del $i $ip 
    echo "$(date) - IP address $ip was removed from IP set '$i'." | tee -a /var/log/myfire.log
  fi
done

for i in $(echo $ipsets | sed "s/,/ /g")
do
  ipset_db="/var/lib/myfire/$(echo $i).db"
  ipset_db_tmp="/var/lib/myfire/$(echo $i).tmp"
  grep -v $ip_esc $ipset_db > $ipset_db_tmp
  mv $ipset_db_tmp $ipset_db
done

echo "$(date) - IP address $ip has been removed from all database files." | tee -a /var/log/myfire.log

echo "$(date) - *** '$cmd' END ***" | tee -a /var/log/myfire.log
