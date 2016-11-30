#!/bin/bash

if [ ! "$(id -u)" = "0" ] ; then
  echo "You need root permissions."
  exit 1
fi

input=badips.db       # Name of database (will be downloaded with this name)
level=4               # Blog level: not so bad/false report (0) over confirmed bad (3) to quite aggressive (5) (see www.badips.com for that)
service=any           # Logged service (see www.badips.com for that)

input_tmp="$(echo $input).tmp"

cd /var/lib/myfire

echo "$(date) - Downloading bad IPs list to temporary file '/var/lib/myfire/$input_tmp'." | tee -a /var/log/myfire.log
wget -qO- http://www.badips.com/get/list/${service}/$level > $input_tmp || { echo "$(date) - $0: Unable to download ip list." | tee -a /var/log/myfire.log; exit 1; }

echo "$(date) - Delete old IPs list '/var/lib/myfire/$input'." | tee -a /var/log/myfire.log
rm -f $input

mv $input_tmp $input
echo "$(date) - IP database '/var/lib/myfire/$input' has been prepared." | tee -a /var/log/myfire.log

exit 0

