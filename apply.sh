#!/bin/bash

unset SUCCESS
on_exit() {
  if [ -z "$SUCCESS" ]; then
    echo "ERROR: $0 failed.  Please fix the above error."
    exit 1
  else
    echo "SUCCESS: $0 has completed."
    exit 0
  fi
}
trap on_exit EXIT

http_patch() {
  PATCHNAME=$(basename $1)
  curl -L -o $PATCHNAME -O -L $1
  cat $PATCHNAME |patch -p1
  rm $PATCHNAME
}

# Change directory verbose
cdv() {
  echo
  echo "*****************************"
  echo "Current Directory: $1"
  echo "*****************************"
  cd $BASEDIR/$1
}

# Change back to base directory
cdb() {
  cd $BASEDIR
}

# Sanity check
if [ -d ../.repo ]; then
  cd ..
fi
if [ ! -d .repo ]; then
  echo "ERROR: Must run this script from the base of the repo."
  SUCCESS=true
  exit 255
fi

# Save Base Directory
BASEDIR=$(pwd)

# Abandon auto topic branch
set -e
. build/envsetup.sh

################ Apply Patches Below ####################
#device fixes
#79135  g3-common: Change LCD density to 560dpi
#79630  media_profiles: fix 4k recording profile
#81089  camerawrapper: chill out the logs
#81582  telephony: show apn settings
#82679  ls990: add network mode settings
#82672  audio: disable use.dedicated.device.for.voip
#82710  ls990: clean up overlay
#82711  ls990: enable svdo and get ismi from sim    

#Ril Fixes
#79749  DCTracker: HACK Fix eHRPD/LTE data connection
#79764  Telephony: DcTracker: Fix CDMA APN Data issues.
#80684  Revert "Telephony: fix getIccOperatorNumeric"
#80685  TeleService: Change the netType get interface

#NFC fixes <-disabled for now
#80229  ls990: select correct nfc config
#80240  ls990: use pn544 as NFC chipset and include lib



repopick -b 79135 79630 81089 79749 79764 80684 80685 82679 82672 82710 82711 82728


##### SUCCESS ####
SUCCESS=true
exit 0
