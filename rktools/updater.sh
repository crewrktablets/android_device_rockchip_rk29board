#!/tmp/busybox sh
#
# Filsystem Conversion Script for Samsung Galaxy SL
# (c) 2011 by Teamhacksung
#Modded to rockchip by vurrut

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

# unmount everything
/tmp/busybox umount -l /system
/tmp/busybox umount -l /cache
/tmp/busybox umount -l /data
/tmp/busybox umount -l /emmc
/tmp/busybox umount -l /sdcard

# create directories
/tmp/busybox mkdir -p /system
/tmp/busybox mkdir -p /cache
/tmp/busybox mkdir -p /data
/tmp/busybox mkdir -p /sdcard
/tmp/busybox mkdir -p /emmc

# make sure internal sdcard is mounted
if ! /tmp/busybox grep -q /emmc /proc/mounts ; then
    /tmp/busybox mkdir -p /emmc
    /tmp/busybox umount -l /dev/block/mtdblock10
    if ! /tmp/busybox mount -t vfat /dev/block/mtdblock10 /emmc ; then
        /tmp/busybox echo "Cannot mount internal sdcard."
        exit 1
    fi
fi

# remove old log
rm -rf /emmc/cyanogenmod.log

# everything is logged into /emmc/cyanogenmod.log
exec >> /emmc/cyanogenmod.log 2>&1


#
# filesystem conversion
#

# format system if not ext4
if ! /tmp/busybox mount -t ext4 /dev/block/mtdblock9 /system ; then
    /tmp/busybox umount /system
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /data /dev/block/mtdblock9
fi

# format cache if not ext4
if ! /tmp/busybox mount -t ext4 /dev/block/mtdblock6 /cache ; then
    /tmp/busybox umount /cache
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /data /dev/block/mtdblock6
fi

# format data if not ext4
if ! /tmp/busybox mount -t ext4 /dev/block/mtdblock7 /data ; then
    /tmp/busybox umount /data
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -a /data /dev/block/mtdblock7
fi

# unmount everything
/tmp/busybox umount -l /system
/tmp/busybox umount -l /cache
/tmp/busybox umount -l /data
/tmp/busybox umount -l /emmc
/tmp/busybox umount -l /sdcard

exit 0
