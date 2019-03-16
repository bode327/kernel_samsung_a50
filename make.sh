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
NAME=Optimized_Kernel
DATE=$(date +'%Y%m%d-%H%M')
BUILDVER=V5
BUILDTYPE=ONEUI
export LOCALVERSION=-${NAME}-${BUILDTYPE}_${BUILDVER}
KERNEL_ZIP_NAME=${NAME}-${BUILDTYPE}_${BUILDVER}-${DATE}.zip

# CCACHE
export CCACHE="$(which ccache)"
export USE_CCACHE=1
ccache -M 50G
export CCACHE_COMPRESS=1

# TC LOCAL PATH
#export CROSS_COMPILE=$(pwd)/gcc/bin/aarch64-linux-android-
export CROSS_COMPILE=$(pwd)/GCC_11.X/bin/aarch64-linux-gnu-
export CLANG_TRIPLE=$(pwd)/clang/bin/aarch64-linux-gnu-
export CC=$(pwd)/clang/bin/clang

# Check if have gcc/32 & clang folder
#if [ ! -d "$(pwd)/gcc/" ]; then
#   git clone --depth 1 git://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 gcc
#fi

#if [ ! -d "$(pwd)/clang/" ]; then
#   git clone --depth 1 https://github.com/PrishKernel/toolchains.git -b proton-clang12 clang
#fi

clear
echo "Select"
echo "1 = Clear"
echo "2 = Clean Build"
echo "3 = Dirty Build"
echo "4 = Kernel+zip"
echo "5 = AIK+ZIP"
echo "6 = Anykernel"
echo "7 = Exit"
echo "8 = TEST"
echo "9 = KernelDirty+zip"
read n

if [ $n -eq 1 ]; then
echo "========================"
echo "Clearing & making clear"
echo "========================"
make clean && make mrproper
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./output/*.zip
rm -rf ./out
rm ./Optimized/AIK/image-new.img
rm ./Optimized/AIK/ramdisk-new.cpio.empty
rm ./Optimized/AIK/split_img/boot.img-zImage
rm ./Optimized/AK/Image
rm ./Optimized/ZIP/Optimized/NXT/boot.img
rm ./Optimized/ZIP/Optimized/A50/boot.img
rm ./Optimized/ZIP/Optimized/A50/boot.img
rm ./Optimized/AK/1.zip
rm -rf A50
fi

if [ $n -eq 2 ]; then
echo "==============="
echo "Building Clean"
echo "==============="
make clean && make mrproper
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./output/*.zip
rm ./Optimized/AIK/image-new.img
rm ./Optimized/AIK/ramdisk-new.cpio.empty
rm ./Optimized/AIK/split_img/boot.img-zImage
rm ./Optimized/AK/Image
rm ./Optimized/ZIP/Optimized/NXT/boot.img
rm ./Optimized/ZIP/Optimized/A50/boot.img
rm ./Optimized/ZIP/Optimized/A50/boot.img
rm ./Optimized/AK/*.zip
clear
############################################
# If other device make change here
############################################
echo "==============="
echo "Building Clean"
echo "==============="
make O=out A50_defconfig
cp -r ./security/samsung/defex_lsm/cert/*.der ./out/security/samsung/defex_lsm/cert/
make O=out -j$(nproc --all)
echo ""
echo "Kernel Compiled"
echo ""
cp -r .out/arch/arm64/boot/Image ./Optimized/AIK/split_img/boot.img-zImage
cp -r .out/arch/arm64/boot/Image ./Optimized/AK/Image
fi

if [ $n -eq 3 ]; then
echo "============"
echo "Dirty Build"
echo "============"
############################################
# If other device make change here
############################################
make O=out A50_defconfig
cp -r ./security/samsung/defex_lsm/cert/*.der ./out/security/samsung/defex_lsm/cert/
make O=out -j$(nproc --all)
echo ""
echo "Kernel Compiled"
echo ""
rm ./Optimized/AIK/split_img/boot.img-zImage
cp -r .out/arch/arm64/boot/Image ./Optimized/AIK/split_img/boot.img-zImage
rm ./Optimized/AK/Image
cp -r .out/arch/arm64/boot/Image ./Optimized/AK/Image
echo "====================="
echo "Dirty Build Finished"
echo "====================="
fi

if [ $n -eq 4 ]; then
echo "======================="
echo "Making kernel with ZIP"
echo "======================="
make clean && make mrproper
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./output/*.zip
rm ./Optimized/AIK/image-new.img
rm ./Optimized/AIK/ramdisk-new.cpio.empty
rm ./Optimized/AIK/split_img/boot.img-zImage
rm ./Optimized/AK/Image
rm ./Optimized/ZIP/Optimized/NXT/boot.img
rm ./Optimized/ZIP/Optimized/D/A50/boot.img
rm ./Optimized/ZIP/Optimized/A50/boot.img
rm ./Optimized/AK/*.zip
clear
############################################
# If other device make change here
############################################
echo "======================="
echo "Making kernel with ZIP"
echo "======================="
make O=out A50_defconfig
cp -r ./security/samsung/defex_lsm/cert/*.der ./out/security/samsung/defex_lsm/cert/
make O=out -j$(nproc --all)
echo "Kernel Compiled"
echo ""
echo "======================="
echo "Packing Kernel INTO ZIP"
echo "======================="
echo ""
cp -r .out/arch/arm64/boot/Image ./Optimized/AIK/split_img/boot.img-zImage
cp -r .out/arch/arm64/boot/Image ./Optimized/AK/Image
./Optimized/AIK/repackimg.sh
cp -r .out/Optimized/AIK/image-new.img ./Optimized/ZIP/Optimized/D/A50/boot.img
cd Optimized/ZIP
echo "==========================="
echo "Packing into Flashable zip"
echo "==========================="
./zip.sh
cd ../..
cp -r ./Optimized/ZIP/1.zip ./output/${KERNEL_ZIP_NAME}
cd output
echo ""
pwd
cd ..
echo " "
echo "======================================================="
echo "get OptimizedKernel-Px-QQ-A50.zip from upper given path"
echo "======================================================="
fi

if [ $n -eq 5 ]; then
echo "====================="
echo "Transfering Files"
echo "====================="
rm ./Optimized/AIK/split_img/boot.img-zImage
rm ./output/Pri*
cp -r .out/arch/arm64/boot/Image ./output/Zimage/Image
cp -r .out/arch/arm64/boot/Image ./AIK/split_img/boot.img-zImage
./Optimized/AIK/repackimg.sh
cp -r ./Optimized/AIK/image-new.img ./Optimized/ZIP/Optimized/D/A50/boot.img
cd Optimized/ZIP
echo " "
echo "==========================="
echo "Packing into Flashable zip"
echo "==========================="
./zip.sh
cd ../..
cp -r ./Optimized/ZIP/1.zip ./output/${KERNEL_ZIP_NAME}
cd output
cd ..
echo " "
pwd
echo "======================================================"
echo "get OptimizedKernel-Rx-M21dd.zip from upper given path"
echo "======================================================"
fi

if [ $n -eq 6 ]; then
echo "===================="
echo "ADDING IN ANYKERNEL"
echo "===================="
rm ./output/Any*
rm ./Optimized/AK/Image
cp -r .out/arch/arm64/boot/Image ./Optimized/AK/Image
cd Optimized/AK
echo " "
echo "=========================="
echo "Packing into Anykernelzip"
echo "=========================="
./zip.sh
cd ../..
cp -r ./Optimized/AK/1*.zip ./output/OptimizedKernel-ONEUI-V1-Ak-A50.zip
cd output
cd ..
echo " "
pwd
echo "============================================"
echo "get Anykernel.zip from upper given path"
echo "============================================"
fi

if [ $n -eq 7 ]; then
echo "========"
echo "Exiting"
echo "========"
exit
fi

if [ $n -eq 8 ]; then
echo "======================="
echo "Making kernel with ZIP"
echo "======================="
make clean && make mrproper
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./output/*.zip
rm ./Optimized/AIK/image-new.img
rm ./Optimized/AIK/ramdisk-new.cpio.empty
rm ./Optimized/AIK/split_img/boot.img-zImage
rm ./Optimized/AK/Image
rm ./Optimized/ZIP/Optimized/NXT/boot.img
rm ./Optimized/ZIP/Optimized/A50/boot.img
rm ./Optimized/ZIP/Optimized/A50/boot.img
rm ./Optimized/AK/*.zip
rm ./TEST/*.zip
clear
############################################
# If other device make change here
############################################
echo "======================="
echo "Making kernel with ZIP"
echo "======================="
make O=out A50_defconfig
cp -r ./security/samsung/defex_lsm/cert/*.der ./out/security/samsung/defex_lsm/cert/
make O=out -j$(nproc --all)
echo "Kernel Compiled"
echo ""
echo "======================="
echo "Packing Kernel INTO ZIP"
echo "======================="
echo ""
cp -r .out/arch/arm64/boot/Image ./Optimized/AIK/split_img/boot.img-zImage
cp -r .out /arch/arm64/boot/Image ./Optimized/AK/Image
./Optimized/AIK/repackimg.sh
cp -r ./Optimized/AIK/image-new.img ./TEST/Optimized/D/A50/boot.img
rm ./TEST/*.zip
cd TEST
echo "==========================="
echo "Packing into Flashable zip"
echo "==========================="
. zip.sh
cd ..
cp -r ./TEST/*.zip ./output/OptimizedKernel-TEST-ONEUI-V1-A50.zip
cd output
echo ""
pwd
cd ..
echo " "
echo "======================================================="
echo "get OptimizedKernel-Vx-RR-A50.zip from upper given path"
echo "======================================================="
fi

if [ $n -eq 9 ]; then
echo "======================="
echo "Making kernel Dirty with ZIP"
echo "======================="
#make clean && make mrproper
rm ./arch/arm64/boot/Image
rm ./arch/arm64/boot/Image.gz
rm ./Image
rm ./output/*.zip
rm ./Optimized/AIK/image-new.img
rm ./Optimized/AIK/ramdisk-new.cpio.empty
rm ./Optimized/AIK/split_img/boot.img-zImage
rm ./Optimized/AK/Image
rm ./Optimized/ZIP/Optimized/NXT/boot.img
rm ./Optimized/ZIP/Optimized/D/A50/boot.img
rm ./Optimized/ZIP/Optimized/A50/boot.img
rm ./Optimized/AK/*.zip
#clear
############################################
# If other device make change here
############################################
echo "======================="
echo "Making kernel Dirty with ZIP"
echo "======================="
make O=out A50_defconfig
cp -r ./security/samsung/defex_lsm/cert/*.der ./out/security/samsung/defex_lsm/cert/
make O=out -j$(nproc --all)
echo "Kernel Compiled"
echo ""
echo "======================="
echo "Packing Kernel INTO ZIP"
echo "======================="
echo ""
cp -r .out/arch/arm64/boot/Image ./Optimized/AIK/split_img/boot.img-zImage
cp -r .out/arch/arm64/boot/Image ./Optimized/AK/Image
./Optimized/AIK/repackimg.sh
cp -r ./Optimized/AIK/image-new.img ./Optimized/ZIP/Optimized/D/A50/boot.img
cd Optimized/ZIP
echo "==========================="
echo "Packing into Flashable zip"
echo "==========================="
./zip.sh
cd ../..
cp -r ./Optimized/ZIP/1.zip ./output/DIRTY_${KERNEL_ZIP_NAME}
cd output
echo ""
pwd
cd ..
echo " "
echo "======================================================="
echo "get OptimizedKernel-Px-QQ-A50.zip from upper given path"
echo "======================================================="
fi
