LS990/LG G3 Sprint Build Instructions
=======================
http://wiki.cyanogenmod.org/w/Build_for_ls990
```
mkdir -p android/CM12
cd android/CM12
repo init -u git://github.com/CyanogenMod/android.git -b cm-12.0
```

Modify your `.repo/local_manifest/roomservice.xml` as follows:

```xml
<?xml version="1.0" encoding="UTF-8"?>
  <manifest>
    <project name="Hrubak/ls990-tools.git" path="ls990-tools" remote="github" revision="cm-12.0" />
    <project name="TheMuppets/proprietary_vendor_lge" path="vendor/lge" remote="github" />
    <!-- common -->
    <project name="CyanogenMod/android_device_qcom_common" path="device/qcom/common" remote="github" />
    <project name="CyanogenMod/android_hardware_qcom_fm" path="hardware/qcom/fm" remote="github" />
    <!-- lg -->
    <project name="CyanogenMod/android_device_lge_g3-common" path="device/lge/g3-common" remote="github" />
    <project name="CyanogenMod/android_kernel_lge_g3" path="kernel/lge/g3" remote="github" />
    <project name="CyanogenMod/android_device_lge_ls990" path="device/lge/ls990" remote="github" />
  </manifest>
```

```
repo sync
vendor/cm/get-prebuilts
```

Auto Apply Patches
==================
This script will remove any topic branches named auto, then apply all patches under topic branch auto.

```
ls990-tools/apply.sh
```
Usage: 
```
repo start auto 'path'                            #start a new branch 'auto' and set the path to your project
echo "say something about the patch"              #echo something
cdv 'same path ^'                                 #cd to the project path
git reset --hard                                  #make the project clean
git fetch, git revert, git something put it here  #add you cherry-picks, reverts, etc here
cdb                                               #cd back to working_dir
```

Build
=====
```
. build/envsetup.sh && brunch ls990
```
