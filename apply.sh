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

#repo start auto frameworks/base
#echo "Add signal strength mod"
#cdv frameworks/base
#git reset --hard
#http_patch https://dl.dropboxusercontent.com/u/13144052/CM11/hrubak/0001-SIGNAL-STRENGTH-MOD.patch
#http_patch https://dl.dropboxusercontent.com/u/13144052/CM11/hrubak/0001-Make-the-signalbars-show-when-not-connected-or-conne.patch
#cdb

repopick -b 76738
repopick -b 77856 78857 78014 78017 78023

##### SUCCESS ####
SUCCESS=true
exit 0
