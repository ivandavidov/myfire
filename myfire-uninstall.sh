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

echo "$(date) - Uninstalling MyFire version '0.1'." | tee -a /var/log/myfire.log

unlink /usr/sbin/myfire-black >/dev/null 2>&1
unlink /usr/sbin/myfire-download-badips >/dev/null 2>&1
unlink /usr/sbin/myfire-download-torips >/dev/null 2>&1
unlink /usr/sbin/myfire-green >/dev/null 2>&1
unlink /usr/sbin/myfire-process >/dev/null 2>&1
unlink /usr/sbin/myfire-report-badip >/dev/null 2>&1
unlink /usr/sbin/myfire-reset >/dev/null 2>&1
unlink /usr/sbin/myfire-uninstall >/dev/null 2>&1
unlink /usr/sbin/myfire-white >/dev/null 2>&1
echo "$(date) - Removed symbolic links from  directory '/usr/sbin'." | tee -a /var/log/myfire.log

rm -rf /var/lib/myfire
rm -rf /opt/myfire
echo "$(date) - Operational directories have been removed." | tee -a /var/log/myfire.log

echo "$(date) - You need to delete manually the log file '/var/log/myfire.log'." | tee -a /var/log/myfire.log
echo "$(date) - MyFire version '0.1' has been uninstalled." | tee -a /var/log/myfire.log

echo "$(date) - *** '$cmd' END ***" | tee -a /var/log/myfire.log

