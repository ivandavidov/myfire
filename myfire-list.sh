#!/bin/bash

ipsets=whiteips,blackips,torips,badips

if [ ! "$(id -u)" = "0" ] ; then
  echo "You need root permissions."
  exit 1
fi

if [ "$1" = "" ] ; then
  echo "You need to provide IP DB name as parameter."
  exit 1
fi

args="$@"

if [ "$args" = "" ] ; then
  cmd="$0"
else
  cmd="$0 $args"
fi

if [ ! -f /var/lib/myfire/$1ips.db ]
then
  echo "DB file '/var/lib/myfire/$1ips.db' does not exist. Cannot continue."
  exit 1
fi

cat /var/lib/myfire/$1ips.db
