#!/bin/bash -e

# Run this script from within the aok folder
# If using within Chrome OS, aok should be in /usr/local so it can read/write

tools_check () {
echo "Checking tools..."
if [ "$EUID" != 0 ]; then
  echo "Root privilege not found, quitting."
  exit 1
fi
crossystem | grep dev || echo "crossystem not found. OK."
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
  echo "Cannot download latest md5. Using existing local copy if it exists."
}
md5sum -c ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5 || {
  curl -LO http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-chromebook-latest.tar.gz
  md5sum -c ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5
} || {
  echo "Arch Linux distribution unavailable. Check your Internet connection."
  exit 1
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
tar --warning=no-unknown-keyword -xf distro/ArchLinuxARM-armv7-chromebook-latest.tar.gz -C rootfs --checkpoint=.500
dd if=rootfs/boot/vmlinux.kpart of=${DEVICE}${PARTITION_1} status=progress

## Copy custom scripts, images, etc. to /root for easy access upon install
install -o root -g root -m 0644 *.txt rootfs/root/
install -o root -g root -m 0755 *.sh rootfs/root/
cp -r files rootfs/root
cp -r extra rootfs/root

## Make extra scripts executable
chmod +x rootfs/root/extra/*.sh

## Also install images where they should go
## DEPENDS: files/arch_linux_gnome_menu_icon_by_byamato.png
## DEPENDS: files/bright_background_light_texture_50370_1366x768.jpg

# INSTALL TEXTURED GREY WALLPAPER
install -o root -g root -m 0644 -D \
files/bright_background_light_texture_50370_1366x768.jpg \
rootfs/usr/share/backgrounds/xfce

## ARCH LINUX ICON
install -o root -g root -m 0644 -D \
files/arch_linux_gnome_menu_icon_by_byamato.png \
rootfs/usr/share/icons

## LIGHTDM LOGIN BACKGROUND
install -o root -g root -m 0644 -D \
files/linux_archlinux_os_blue_black_logo_30861_1366x768.jpg \
rootfs/usr/share/pixmaps

## LIGHTDM BACKGROUND SETTINGS
install -o root -g root -m 0644 -D \
files/lightdm-gtk-greeter.conf \
rootfs/etc/lightdm

## Now place a script on the Desktop
install -o a -g a -m 0755 -D \
files/Setup-AOK-Style.sh \
rootfs/home/a/Desktop

## Edit root bashrc to have welcome message
echo "dmesg -n 1" >> rootfs/root/.bashrc
echo "echo ''" >> rootfs/root/.bashrc
echo "echo 'Welcome. To finish installing AOK, do the following:'"
echo "echo '1. Type ./2-run-on-first-login.sh and press enter.'" >> rootfs/root/.bashrc
echo "echo '2. Type wifi-menu and press enter to get online.'" >> rootfs/root/.bashrc
echo "echo '3. Type ./3-run-when-online.sh and press enter.'" >> rootfs/root/.bashrc
echo "echo ''" >> rootfs/root/.bashrc

umount rootfs
sync
rmdir rootfs
echo
echo "Arch Linux is Installed."
echo
echo "Would you also like to copy the Arch Linux Distro for future installs?"
read -p "(y/N) > " FUTURE
case "$FUTURE" in
  y|Y)
    mkdir rootfs
    mount ${DEVICE}${PARTITION_2} rootfs
    rsync -ah --info=progress2 distro /rootfs/root
    umount rootfs
    sync
    rmdir rootfs
    echo "Distro copied."
    ;;
  *)
    echo
    ;;
esac
echo "Done."
echo "Reboot and press CTRL-U to boot to SD Card, or CTRL-D to boot Internal Storage."
echo "Username: root"
echo "Password: root"
echo "Would you like to reboot now? (Y/n)"
read -p "> " REBOOT
case "$REBOOT" in
  n|N|no|No|NO|nO)
      ;;
  *)
      reboot
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

