#!/bin/bash

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

month=$(date | awk '{print $2}')
day=$(date | awk '{print $3}')

ips=$(cat /var/log/auth.log | grep $month.*$day | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | awk '!seen[$0]++')

cmd2=
first=true

for ip in $ips
do
  if [ "$first" = "true" ] ; then
    first=false
  else
    ip=" $ip"
  fi

  cmd2="$cmd2$ip"
done

/opt/myfire/myfire-addip.sh blackips $cmd2

echo "$(date) - *** '$cmd' END ***" | tee -a /var/log/myfire.log

