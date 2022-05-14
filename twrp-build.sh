#!bin/bash

# Go to the working directory
mkdir ~/TWRP && cd ~/TWRP
# Configure git
git config --global user.email "100Daisy@protonmail.com"
git config --global user.name "100Daisy"
git config --global color.ui false
# Sync the source
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-11
repo sync  -f --force-sync --no-clone-bundle --no-tags -j$(nproc --all)
git clone --depth=1 https://github.com/100Daisy/android_device_motorola_guamp -b android-11 device/motorola/guamp
git clone --depth=1 https://github.com/100Daisy/android_kernel_motorola_guamp -b android-4.19-stable kernel/motorola/guamp
# Build recovery image
export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; lunch twrp_guamp-eng; make -j$(nproc --all) recoveryimage
# Rename and copy the files
twrp_version=$(cat ~/TWRP/bootable/recovery/variables.h | grep "define TW_MAIN_VERSION_STR" | cut -d '"' -f2)
date_time=$(date +"%d%m%Y%H%M")
mkdir ~/final
cp out/target/product/guamp/recovery.img ~/final/twrp-$twrp_version-guamp-"$date_time"-unofficial.img
# Upload to oshi.at
curl -T ~/final/*.img https://oshi.at
