#!/bin/bash

rom_fp="$(date +%y%m%d)"
mkdir -p release/$rom_fp/
set -e

(cd device/phh/treble; bash generate.sh bliss)

export ANDROID_JACK_VM_ARGS="-Xmx8g -Dfile.encoding=UTF-8 -XX:+TieredCompilation"

. build/envsetup.sh

export LC_ALL=C

buildVariant() {
        lunch $1
        make BUILD_NUMBER=$rom_fp installclean
        make BUILD_NUMBER=$rom_fp -j32 systemimage
        make BUILD_NUMBER=$rom_fp vndk-test-sepolicy
        cp $OUT/system.img release/$rom_fp/system-${2}.img
        #xz -c $OUT/system.img > release/$rom_fp/system-${2}.img.xz
}

#buildVariant treble_arm64_avN-userdebug arm64-aonly-vanilla-nosu
buildVariant treble_arm64_agS-userdebug arm64-aonly-gapps-su

#buildVariant treble_arm64_bvN-userdebug arm64-ab-vanilla-nosu
#buildVariant treble_arm64_bgS-userdebug arm64-ab-gapps-su

#buildVariant treble_arm_avN-userdebug arm-aonly-vanilla-nosu
