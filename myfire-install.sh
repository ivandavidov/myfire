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

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd $DIR

echo "$(date) - Installing MyFire version '0.1'." | tee -a /var/log/myfire.log

mkdir -p /var/lib/myfire
mkdir -p /opt/myfire
echo "$(date) - Operational directories have been created." | tee -a /var/log/myfire.log

cp *.sh /opt/myfire
echo "$(date) - Scripts have been copied in directory '/opt/myfire'." | tee -a /var/log/myfire.log

cd /opt/myfire
chown root:root *.sh
chmod 755 *.sh
echo "$(date) - Scripts are executable only by 'root'." | tee -a /var/log/myfire.log

cd /var/lib/myfire
touch badips.db
touch torips.db
touch whiteips.db
touch blackips.db
chown root:root *.db
chmod 640 *.db
echo "$(date) - Database files have been created." | tee -a /var/log/myfire.log

cd /var/log
chown root:root myfire.log
chmod 640 myfire.log
echo "$(date) - Log file has been secured." | tee -a /var/log/myfire.log

unlink /usr/sbin/myfire-black >/dev/null 2>&1
ln -s /opt/myfire/myfire-black.sh /usr/sbin/myfire-black
unlink /usr/sbin/myfire-download-badips >/dev/null 2>&1
ln -s /opt/myfire/myfire-download-badips.sh /usr/sbin/myfire-download-badips
unlink /usr/sbin/myfire-download-torips >/dev/null 2>&1
ln -s /opt/myfire/myfire-download-torips.sh /usr/sbin/myfire-download-torips
unlink /usr/sbin/myfire-examine-auth >/dev/null 2>&1
ln -s /opt/myfire/myfire-examine-auth.sh /usr/sbin/myfire-examine-auth
unlink /usr/sbin/myfire-examine-auth >/dev/null 2>&1
ln -s /opt/myfire/myfire-examine-auth.sh /usr/sbin/myfire-examine-auth
unlink /usr/sbin/myfire-green >/dev/null 2>&1
ln -s /opt/myfire/myfire-green.sh /usr/sbin/myfire-green
unlink /usr/sbin/myfire-process >/dev/null 2>&1
ln -s /opt/myfire/myfire-process.sh /usr/sbin/myfire-process
unlink /usr/sbin/myfire-rebuild >/dev/null 2>&1
ln -s /opt/myfire/myfire-rebuild.sh /usr/sbin/myfire-rebuild
unlink /usr/sbin/myfire-report-badip >/dev/null 2>&1
ln -s /opt/myfire/myfire-report-badip.sh /usr/sbin/myfire-report-badip
unlink /usr/sbin/myfire-reset >/dev/null 2>&1
ln -s /opt/myfire/myfire-reset.sh /usr/sbin/myfire-reset
unlink /usr/sbin/myfire-uninstall >/dev/null 2>&1
ln -s /opt/myfire/myfire-uninstall.sh /usr/sbin/myfire-uninstall
unlink /usr/sbin/myfire-white >/dev/null 2>&1
ln -s /opt/myfire/myfire-white.sh /usr/sbin/myfire-white
echo "$(date) - Added symbolic links in directory '/usr/sbin'." | tee -a /var/log/myfire.log
echo "$(date) - The log file is '/var/log/myfire.log'." | tee -a /var/log/myfire.log
echo "$(date) - MyFire version '0.1' has been installed." | tee -a /var/log/myfire.log

echo "$(date) - *** '$cmd' END ***" | tee -a /var/log/myfire.log

