#!/bin/bash

if [ ! "$(id -u)" = "0" ] ; then
  echo "You need root permissions."
  exit 1
fi

if [ "$1" = "" ] ; then
  echo "You need to provide command."
  exit 1
fi

args="$@"

if [ "$args" = "" ] ; then
  cmd="$0"
else
  cmd="$0 $args"
fi

echo "`date` - *** '$cmd' BEGIN ***" | tee -a /var/log/myfire.log

subcmd=$1
shift
params="$@"
newcmd="/opt/myfire/myfire-${subcmd}.sh"

if [ ! -f $newcmd ] ; then
  echo "Script file '${newcmd}' does not exist."
  exit 1
fi

if [ "${params}" = "" ] ; then
  echo "`date` - Executing script '${newcmd}' with no params." | tee -a /var/log/myfire.log
else
  echo "`date` - Executing script '${newcmd}' with params '${params}'." | tee -a /var/log/myfire.log
fi

${newcmd} ${params}

echo "$(date) - *** '$cmd' END ***" | tee -a /var/log/myfire.log
