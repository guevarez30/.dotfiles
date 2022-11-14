#!/usr/bin/env bash
get_from_file() {
   dev=$1
   name=
   if [ ! -f /tmp/bt-devices.txt ]; then
      touch /tmp/bt-devices.txt
      echo ""
      return
   fi
   for i in `cat /tmp/bt-devices.txt`; do
      d=`echo $i | awk -F:: '{print $1}'`
      if [ $d = $dev ]; then
         name=`echo $i | awk -F:: '{print $2}'`
      fi
   done
   echo "${name}"
}

store_file() {
   dev=$1
   name="${2}"
   echo "$dev::${name}" >> /tmp/bt-devices.txt
}

connections=`hcitool con | sed -n 2p`
if [ ! -z "$connections" ]; then
   # We have a connection, we want to get the name from a file if we've had
   # it from there before because getting the name of the device connected
   # is very slow and costly.
   dev=`echo $connections | awk '{print $3}'`
   name=`get_from_file $dev`
   if [ -z "$name" ]; then
      name=`hcitool name $dev | awk '{print $1}'`
      if [ ! -z "${name}" ]; then
         store_file $dev "${name}"
      fi
   fi
   echo " $name"
   echo " $name"
   echo "#E85A84\n"
else
   echo ""
   echo ""
fi
