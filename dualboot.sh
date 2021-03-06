#!/bin/bash
kdir=`readlink -f .`
cd $kdir
cd ..
home=`readlink -f .`
ramdisk=$home/ramdisk_m250l/dualboot # cwm 6.0.15 update for ML1
toolchain=$home/toolchain/linaro_4.8/bin/arm-linux-gnueabihf- # linaro 4.8.1 ( 2013/11 )
version=dualboot
defconfig_name=gsd_defconfig

export ARCH=arm
export CROSS_COMPILE=$toolchain
cd $kdir
mkdir out
rm -rf out/*
rm -rf ./pack/dualboot/boot/zImage
mv .git git
make $defconfig_name
make mrproper
make $defconfig_name
rm -rf $ramdisk/lib/modules/*

make -j16 CONFIG_INITRAMFS_SOURCE="$ramdisk"
find . -name "*.ko" -exec mv {} $ramdisk/lib/modules/ \;
make clean
make -j16 CONFIG_INITRAMFS_SOURCE="$ramdisk"
cp ./arch/arm/boot/zImage ./pack/dualboot/boot/
cd pack/dualboot
zip -r [$version].$(date -u +%m)-$(date -u +%d)-$(date -u +%s).zip ./
mv ./*.zip $kdir/out/
cd $kdir
make mrproper
mv git .git
