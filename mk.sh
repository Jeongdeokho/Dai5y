#!/bin/bash
kdir=`readlink -f .`
cd $kdir
cd ..
home=`readlink -f .`
ramdisk=$home/ramdisk_m250l/cwm # cwm 6.0.15 update for ML1
toolchain=$home/toolchain/linaro_4.8/bin/arm-linux-gnueabihf- # linaro 4.8.1 ( 2013/11 )
version=Dev
defconfig_name=gsd_defconfig

export ARCH=arm
export CROSS_COMPILE=$toolchain
cd $kdir
mkdir out
rm -rf out/*
rm -rf ./pack/boot/zImage
mv .git git
make $defconfig_name
make mrproper
make $defconfig_name
rm -rf $ramdisk/lib/modules/*

make -j16 CONFIG_INITRAMFS_SOURCE="$ramdisk"
find . -name "*.ko" -exec mv {} $ramdisk/lib/modules/ \;
make clean
make -j16 CONFIG_INITRAMFS_SOURCE="$ramdisk"
cp ./arch/arm/boot/zImage ./pack/boot/
cd pack
zip -r [D][a][i][5][y].[$version].$(date -u +%m).$(date -u +%d).zip ./
mv ./*.zip ../out/
cd ..
make mrproper
mv git .git
