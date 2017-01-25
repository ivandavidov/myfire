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

ips=$(cat /var/log/auth.log | egrep "^$month[ ]{1,2}$day" | grep -oE '[1-9][0-9]{0,2}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | awk '!seen[$0]++')

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

if [ ! "$cmd2" = "" ] ; then
  /opt/myfire/myfire-addip.sh blackips $cmd2
else
  echo "$(date) - There are no IPs in the log file." | tee -a /var/log/myfire.log
fi

echo "$(date) - *** '$cmd' END ***" | tee -a /var/log/myfire.log

