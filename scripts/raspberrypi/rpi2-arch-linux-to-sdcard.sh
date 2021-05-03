#!/bin/bash

# <http://archlinuxarm.org/platforms/armv7/broadcom/raspberry-pi-2>

echo -e "\n\nArch Linux ARM to SD Card"
echo -e "for the Raspberry Pi 2"
echo -e "(and for the Raspberry Pi 3, if you don't need to use the unofficial arm64 variant)\n\n"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo -e "\nAll drives on this computer:\n"
ls -1 /dev/sd?

echo -e "\nLast messages in syslog:\n"
dmesg | tail

echo -e "\nChoose sd card (like /dev/sdX):\n"
read SDCARD

echo -e "\n\nCurrent partitioning of $SDCARD:\n"
parted $SDCARD print

echo -e "\n\nYou chose $SDCARD\nAre you sure to continue? Press Ctrl-C to abort!"
read

cd /tmp

echo "Removing any downloaded and leftover Arch Linux ARM image"
rm ArchLinuxARM-rpi-2-latest.tar.gz

echo -e "\nDownloading the Arch Linux ARM root filesystem:\n"
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz

# Sometimes the download server is slow. In that case, try a different one instead:

if [ $? -ne 0 ]; then
  echo "Could not download the image file, please check the mirror"
  exit 1
fi

echo -e "\nUnmounting partitions found on ${SDCARD}\n"
for MOUNT in ${SDCARD}?
do
  echo $MOUNT
  umount $MOUNT
done

parted -s $SDCARD unit s print
parted -s $SDCARD mktable msdos
parted -s $SDCARD mkpart primary fat32 8192s 128MiB
parted -s $SDCARD mkpart primary 128MiB 100%
parted -s $SDCARD unit s print

mkfs.vfat ${SDCARD}1
mkfs.ext4 ${SDCARD}2

mkdir boot
mkdir root

mount ${SDCARD}1 boot
mount ${SDCARD}2 root

echo -e "\nExtracting the root filesystem\n"
bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root
sync

echo -e "\nMoving boot files to the first partition\n"
mv root/boot/* boot

echo -e "\nUnmounting the two partitions\n"
umount boot root

rmdir boot root

echo "Insert the SD card into the Raspberry Pi 2, connect ethernet, and apply 5V power."
echo "Use the serial console or SSH to the IP address given to the board by your router. The username/password combination is alarm/alarm. The default root password is 'root'."

echo ""
echo "Initialize the key-ring: "
echo " pacman-key --init"
echo " pacman-key --populate archlinuxarm"

cd -
