#
#!/bin/bash

echo "Setting Up Environment"
echo ""
export ARCH=arm64
export SUBARCH=arm64
export ANDROID_MAJOR_VERSION=r
export PLATFORM_VERSION=11.0.0

# Export KBUILD flags
export KBUILD_BUILD_USER=Bode327
export KBUILD_BUILD_HOST=auto

# CCACHE
export CCACHE="$(which ccache)"
export USE_CCACHE=1
ccache -M 50G
export CCACHE_COMPRESS=1

# TC LOCAL PATH
export CROSS_COMPILE=$(pwd)/gcc/bin/aarch64-linux-android-
export CLANG_TRIPLE=$(pwd)/clang/bin/aarch64-linux-gnu-
export CC=$(pwd)/clang/bin/clang

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install \
          bison build-essential curl flex git gnupg gperf \
          liblz4-tool libncurses5-dev libsdl1.2-dev libxml2 \
          libxml2-utils lzop pngcrush schedtool \
          squashfs-tools xsltproc zip zlib1g-dev \
          build-essential kernel-package libncurses5-dev \
          bzip2 git python expect \
          gcc-aarch64-linux-gnu g++-aarch64-linux-gnu -y

#
curl https://raw.githubusercontent.com/akhilnarang/scripts/master/setup/android_build_env.sh | bash

# Check if have gcc/32 & clang folder
if [ ! -d "$(pwd)/gcc/" ]; then
   git clone --depth 1 git://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 gcc
fi

if [ ! -d "$(pwd)/clang/" ]; then
   git clone --depth 1 https://github.com/PrishKernel/toolchains.git -b proton-clang12 clang
fi

echo "======================="
echo "Making kernel with ZIP"
echo "======================="
make clean && make mrproper
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./output/*.zip
rm ./PRISH/AIK/image-new.img
rm ./PRISH/AIK/ramdisk-new.cpio.empty
rm ./PRISH/AIK/split_img/boot.img-zImage
rm ./PRISH/AK/Image
rm ./PRISH/ZIP/PRISH/NXT/boot.img
rm ./PRISH/ZIP/PRISH/A50/boot.img
rm ./PRISH/ZIP/PRISH/D/A50/boot.img
rm ./PRISH/AK/*.zip
clear
echo "======================="
echo "Making kernel with ZIP"
echo "======================="
make A50_defconfig
make -j64
echo "Kernel Compiled"
echo ""
echo "======================="
echo "Packing Kernel INTO ZIP"
echo "======================="
echo ""
cp -r ./arch/arm64/boot/Image ./PRISH/AIK/split_img/boot.img-zImage
cp -r ./arch/arm64/boot/Image ./PRISH/AK/Image
./PRISH/AIK/repackimg.sh
cp -r ./PRISH/AIK/image-new.img ./PRISH/ZIP/PRISH/D/A50/boot.img
cd PRISH/ZIP
echo "==========================="
echo "Packing into Flashable zip"
echo "==========================="
./zip.sh
cd ../..
cp -r ./PRISH/ZIP/1.zip ./output/OptimizedKernel-ONEUI-V1-A50dd.zip
