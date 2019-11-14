#!/bin/bash -ev

# Run this script from within the aok folder
# This should be /usr/local/aok within Chrome OS
# Or elsewhere on other systems

tools_check () {
echo "Checking tools..."
if [ "$EUID" != 0 ]; then
  echo "Root privilege not found, quitting."
  exit 1
fi
crossystem || echo "crossystem not found. OK."
curl -V
ping -c 1 archlinuxarm.org || {
  echo "Cannot connect to archlinuxarm.org right now. Might use local data."
}
md5sum --version
umount -V
fdisk -V
cgpt add -h
mkfs -V
dd --version
}

install_arch () {
echo "Starting Arch Linux Installation..."
crossystem dev_boot_usb=1 dev_boot_signed_only=0 || echo -n
mkdir -p distro
cd distro
curl -LO http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5 || {
  echo "Cannot download latest md5. Using existing local copy."
}
md5sum -c ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5 || {
  curl -LO http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-chromebook-latest.tar.gz
  md5sum -c ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5
}
cd -
umount ${DEVICE}* || echo -n
fdisk ${DEVICE} << END
g
n


+16M
y
t
${TYPE}
n



p
w
END
cgpt add -i 1 -P 10 -T 5 -S 1 ${DEVICE} || echo -n

## Avoid mkfs complaining if it's 'apparently in use by the system' but isn't
umount rootfs || echo -n

mkfs.ext4 -F ${DEVICE}${PARTITION_2}
mkdir -p rootfs
mount ${DEVICE}${PARTITION_2} rootfs
tar -xf distro/ArchLinuxARM-armv7-chromebook-latest.tar.gz -C rootfs -v
dd if=rootfs/boot/vmlinux.kpart of=${DEVICE}${PARTITION_1} status=progress

## COPY CUSTOM SCRIPTS AND IMAGES
mkdir -p rootfs/aok
install -o root -g root -m 0644 *.txt rootfs/aok/
install -o root -g root -m 0755 *.sh rootfs/aok/
cp -r files rootfs/aok
cp -r extra rootfs/aok
umount rootfs
sync
rmdir rootfs
echo ""
echo "Arch Linux is Installed."
echo ""
echo "Would you also like to copy the Arch Linux Distro for future installs?"
read -p "(y/N) > " FUTURE
case "$FUTURE" in
  y|Y)
    mkdir rootfs
    mount ${DEVICE}${PARTITION_2} rootfs
    rsync -ah --info=progress2 distro /rootfs/aok
    umount rootfs
    sync
    rmdir rootfs
    echo "Distro copied. Done."
    ;;
  *)
    echo "Done."
    ;;
esac
}

echo
echo "Select the device where you would like to install Arch Linux:"
echo 
echo "0) Laptop (/dev/mmcblk0)"
echo "1) SD Card (/dev/mmcblk1)"
echo "2) VirtualBox SD Card (/dev/sdb)"
echo "q) Quit without making changes"
echo

read -p "> " CHOICE
case "$CHOICE" in
  0)
    DEVICE='/dev/mmcblk0'
    PARTITION_1='p1'
    PARTITION_2='p2'
    TYPE='65'
    tools_check
    install_arch
    ;;
  1)
    DEVICE='/dev/mmcblk1'
    PARTITION_1='p1'
    PARTITION_2='p2'
    TYPE='65'
    tools_check
    install_arch
    ;;
  2)
    DEVICE='/dev/sdb'
    PARTITION_1='1'
    PARTITION_2='2'
    TYPE='64'
    tools_check
    install_arch
    ;;
  *)
    echo "No changes made, quitting."
    ;;
esac

