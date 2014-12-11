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
#78864  sepolicy: add device specific-sepolicies
#79920  keylayout: remove deprecated wake flags
#79630  media_profiles: fix 4k recording profile
#79497  g3: selinux enforcing
#81089  camerawrapper: chill out the logs
#81079  sec_config: update from lollipop release
#Ril Fixes
#79749  DCTracker: HACK Fix eHRPD/LTE data connection
#79764  Telephony: DcTracker: Fix CDMA APN Data issues.
#77856  Telephony: Allow ruim to fetch in CDMA LTE mode
#81087  LgeLteRIL: allow skipping of initial radio power off message
#81088  LgeLteRIL: properly reset radio on RIL_CONNECTED

#NFC fixes <-disabled for now
#80229  ls990: select correct nfc config
#80240  ls990: use pn544 as NFC chipset and include lib


#extras
#81259  g3: death to all modules

repopick -b 79135 78864 79920 79630 79749 81089 81079 79764 77856 81087 81088 81259 80240 80229


##### SUCCESS ####
SUCCESS=true
exit 0
