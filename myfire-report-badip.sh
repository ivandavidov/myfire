#!/bin/sh

if [ ! "$(id -u)" = "0" ] ; then
  echo "You need root permissions."
  exit 1
fi

if [ ! "$1" = "" ] ; then
  echo "You need to provide category as first argument, e.g. 'ssh'."
  echo "Available categories: https://www.badips.com/get/categories"
  exit 1
fi

if [ ! "$2" = "" ] ; then
  echo "You need to provide IP address as second argument."
  exit 1
fi

wget https://www.badips.com/add/$1/$2

