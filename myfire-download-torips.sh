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

input=torips.db
input_tmp="$(echo $input).tmp"

cd /var/lib/myfire

echo "$(date) - Downloading IP list with Tor exit nodes in temporary file '/var/lib/myfire/$input_tmp'." | tee -a /var/log/myfire.log
wget -qO- https://www.dan.me.uk/torlist/?exit  > $input_tmp || { echo "$(date) - $0: Unable to download IP list." | tee -a /var/log/myfire.log; exit 1; }

echo "$(date) - Delete old IPs list '/var/lib/myfire/$input'." | tee -a /var/log/myfire.log
rm -f $input

mv $input_tmp $input
echo "$(date) - IP database '/var/lib/myfire/$input' has been prepared." | tee -a /var/log/myfire.log

echo "$(date) - *** '$cmd' END ***" | tee -a /var/log/myfire.log
