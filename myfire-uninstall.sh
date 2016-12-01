#!/bin/bash

if [ ! "$(id -u)" = "0" ] ; then
  echo "You need root permissions."
  exit 1
fi

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd $DIR

echo "$(date) - Uninstalling MyFire version '0.1'." | tee -a /var/log/myfire.log

unlink /usr/sbin/myfire-black >/dev/null 2>&1
unlink /usr/sbin/myfire-download-badips >/dev/null 2>&1
unlink /usr/sbin/myfire-download-torips >/dev/null 2>&1
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

