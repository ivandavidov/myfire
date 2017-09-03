#!/bin/bash

ipsets=whiteips,blackips,torips,badips

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

/opt/myfire/myfire-reset.sh

for i in $(echo $ipsets | sed "s/,/ /g")
do
  /opt/myfire/myfire-process.sh $i
done

echo "$(date) - *** '$cmd' END ***" | tee -a /var/log/myfire.log
