#!/bin/bash

if [ ! "$(id -u)" = "0" ] ; then
  echo "You need root permissions."
  exit 1
fi

input=torips.db
input_tmp="$(echo $_input).tmp"

cd /var/lib/myfire

echo "$(date) - Downloading IP list with Tor exit nodes in temporary file '/var/lib/myfire/$input_tmp'." | tee -a /var/log/myfire.log
wget -qO- https://www.dan.me.uk/torlist/?exit  > $input_tmp || { echo "$(date) - $0: Unable to download IP list." | tee -a /var/log/myfire.log; exit 1; }

echo "$(date) - Delete old IPs list '/var/lib/myfire/$input'." | tee -a /var/log/myfire.log
rm -f $input

mv $input_tmp $input
echo "$(date) - IP database '/var/lib/myfire/$input' has been prepared." | tee -a /var/log/myfire.log

exit 0

