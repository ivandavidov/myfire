#!/bin/bash

ipt=/sbin/iptables
ips=/sbin/ipset
ipsets=badips,torips,blackips,whiteips

if [ ! "$(id -u)" = "0" ] ; then
  echo "You need root permissions."
  exit 1
fi

if [ "$1" = "" ] ; then
  echo "You need to provide IP set name as first parameter."
  exit 1
fi

if [ "$2" = "" ] ; then
  echo "You need to provide IP address as second parameter."
  exit 1
fi

args="$@"

if [ "$args" = "" ] ; then
  cmd="$0"
else
  cmd="$0 $args"
fi

echo "$(date) - *** '$cmd' BEGIN ***" | tee -a /var/log/myfire.log

custset=$1
input="$(echo $custset).db"

ip=$2
ip_esc=$(echo ${ip//./\\.})

cd /var/lib/myfire

ip_found_in_set=

for i in $(echo $ipsets | sed "s/,/ /g")
do
  ip_found_in_set=$($ips list $i | grep $ip_esc)

  if [ ! "$ip_found_in_set" = "" ] ; then
    echo "$(date) - IP address $ip was found in IP set '$i'." | tee -a /var/log/myfire.log
    ip_found_in_set=$
    break
  fi
done

if [ "$ip_found_in_set" = "" ] ; then
  $ips add $custset $ip
  ip_found_in_set=$custset
  echo "$(date) - IP address $ip was added to IP set '$custset'." | tee -a /var/log/myfire.log
fi

ip_found_db=$(grep $ip_esc $input)

if [ "$ip_found_in_set" = "$custset" -a "$ip_found_db" = "" ] ; then
  echo $ip >> $input
  echo "$(date) - IP address $ip was added to database file '/var/lib/myfire/$input'." | tee -a /var/log/myfire.log
fi

echo "$(date) - *** '$cmd' END ***" | tee -a /var/log/myfire.log

