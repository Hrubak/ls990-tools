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
#79965  ls990: bring up overlays
#79135  g3-common: Change LCD density to 560dpi
#78864  sepolicy: add device specific-sepolicies
#80056  init: cleanup and juggling act
#79920  keylayout: remove deprecated wake flags
#79630  media_profiles: fix 4k recording profile
#79497  g3: selinux enforcing <--NOT YET!!!!
#Ril Fixes
#79749  DCTracker: HACK Fix eHRPD/LTE data connection
#79764  Telephony: DcTracker: Fix CDMA APN Data issues.
#79857  LgeLteRIL: Lollipop fixups for CDMA
#77856  Telephony: Allow ruim to fetch in CDMA LTE mode
#79187  UiccController: Query GET_SIM_STATUS when radio state is ON
#NFC fixes
#80229  ls990: select correct nfc config
#80240  ls990: use pn544 as NFC chipset and include lib


repopick -b 79965 79135 78864 80056 79920 79630 80229 80240 79749 79764 79857 77856 79187

##### SUCCESS ####
SUCCESS=true
exit 0
