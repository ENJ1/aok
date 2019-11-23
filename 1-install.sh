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
curl -V > /dev/null || { echo "curl not found. exiting."; exit 1; }
ping -c 1 archlinuxarm.org > /dev/null || echo "archlinuxarm.org not found. May use local data."
md5sum --version > /dev/null || { echo "md5sum not found. exiting."; exit 1; }
umount -V > /dev/null || { echo "umount not found. exiting."; exit 1; }
fdisk -V
cgpt add -h > /dev/null || { echo "cgpt not found. exiting."; exit 1; }
mkfs -V > /dev/null || { echo "mkfs not found. exiting."; exit 1; }
dd --version > /dev/null || { echo "dd not found. exiting."; exit 1; }
echo "Tools check complete."
}


test_mirrors () {
## Test mirrors and end up with good mirror file
echo "Testing mirrors..."

## Create or reset the working mirrors list file
echo -n > workingmirrors.txt

## Declare an associative array.
## Key: Variable-friendly subdomain name, Value: Speed
declare -A MIRROR_SPEEDS

## All local Arch Linux ARM mirrors, not the main load-balancing mirror
## This is the list from https://archlinuxarm.org/about/mirrors
## Plus the list provided in /etc/pacman.d/mirrorlist
all_Mirrors=(au br2 dk de3 de de4 de5 de6 eu gr hu nl ru sg za tw ca.us nj.us fl.us il.us vn)

## Try to download md5 file for each mirror, recording speeds
for DOMAIN in ${all_Mirrors[@]}; do

  ## Variable names can't have dots, so change it to an underscore
  SAFE_DOMAIN=`echo $DOMAIN | sed --expression='s/\./_/'`

  ## Create a new varaible based on the domain name, and set its value to Download Speed
  ## A higher number is better. Domains that fail will have a null value.
  MIRROR_SPEEDS+=([$SAFE_DOMAIN]=`curl --max-time 5 -LO \
  $DOMAIN.mirror.archlinuxarm.org/os/ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5 \
  2>&1 | grep $'\r100' | grep -o '[^ ]*$' || echo -n`)

  ## What if it fails?
  ## Using "|| echo -n" which will set the variable to null

  ## What if it's a bad md5 file, like a 404?
  ## It should contain the filename, and be only 1 line
  if [ `grep ArchLinuxARM-armv7-chromebook-latest.tar.gz \
      ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5 | wc -l` -eq 1 ]; then

    ## Save the working mirrors to a text file, Format: Speed (tab) Mirror
    if [ -n "${MIRROR_SPEEDS[${SAFE_DOMAIN}]}" ]; then
      echo -e "${MIRROR_SPEEDS[$SAFE_DOMAIN]}\t${DOMAIN}.mirror.archlinuxarm.org" \
        | tee -a workingmirrors.txt
      ## Save the best md5
      cp -u ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5 \
          ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5.temp
      MIRROR_SUCCESS=true
    else
      echo -e "\t${DOMAIN}.mirror.archlinuxarm.org failed completely"
    fi
  else
    echo -e "\t${DOMAIN}.mirror.archlinuxarm.org did not provide the correct file (Likely 404)"
    ## Restore the best md5 if possible
    cp ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5.temp \
        ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5 || :
  fi
  ## now i should have MIRROR_SPEEDS[au] which equals perhaps '180'
  ## now i should have MIRROR_SPEEDS[de5] which equals perhaps '230'
  ## now i should have MIRROR_SPEEDS[ca_us] which equals perhaps '' (null)
  ## this array can be used later to extend functionality
done

echo
echo "Here are your best mirrors:"
echo -e "SPEED\tMIRROR"

## Sort human readable reverse (highest first) to a sorted file
cat workingmirrors.txt.temp | sort -hr | tee bestmirrors.txt || :

## Cleanup
rm -f ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5.temp
rm -f workingmirrors.txt.temp
}

## Offline function, try using local md5 or quit
use_local_md5 () {
  if [ -f ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5 ]; then
    echo "Using existing local md5 file."
  else
    echo "Cannot find md5 file. exiting. Check your Internet connection."
    exit 1
  fi
}

install_arch () {
echo "Starting Arch Linux Installation..."
mkdir -p distro
cd distro

## check if Internet and DNS is working before trying every mirror
## command is repeated because curl is built without metalink support in chrome os.
## it's a small file, so be impatient
if ping -c 1 archlinuxarm.org > /dev/null; then
  curl --max-time 10 -LO \
      mirror.archlinuxarm.org/os/ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5 && \
      MIRROR_SUCCESS=true || :
  test_mirrors
  if "${MIRROR_SUCCESS}" -ne true; then
    echo "Cannot download latest md5: all mirrors failed."
    use_local_md5
  fi
else
    echo "Cannot download latest md5: archlinuxarm.org not found."
    use_local_md5
fi

## Check even if it doesn't exist, or try downloading
md5sum -c ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5 || {
  if ping -c 1 archlinuxarm.org > /dev/null; then
  
    ## Here's where to use a faster mirror from testing
    DOWNLOAD_DONE=false
    DOWNLOAD_ATTEMPT=1
    while [ $DOWNLOAD_ATTEMPT -le 5 ]; do
      TRY_MIRROR=`sed -n "${DOWNLOAD_ATTEMPT}p" bestmirrors.txt | tr -d [:digit:] | tr -d '\t'`
      curl -LO ${TRY_MIRROR}/os/ArchLinuxARM-armv7-chromebook-latest.tar.gz && DOWNLOAD_DONE=true ||
      DOWNLOAD_ATTEMPT=$[$DOWNLOAD_ATTEMPT+1]
    done
    if [ "$DOWNLOAD_DONE" = false ]; then
      echo "Couldn't download Arch Linux. Check your Internet connection reliability."
      exit 1
    }
    md5sum -c ArchLinuxARM-armv7-chromebook-latest.tar.gz.md5 || {
      echo "Arch Linux download was corrupted. You may want to try again."
      exit 1
    }
  else
    echo "Arch Linux local copy unavailable. Can't download: Not online. Exiting."
    exit 1
  fi
}

## Now that everything is ready, truly get started
cd -
umount ${DEVICE}* || echo -n

## Do not change the whitespace here, it is important
## passing "y" in case it asks if sure. harmless if not asked.
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

## Set special flags needed by U-Boot. Don't let so-called-cgpt-errors break the script
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
crossystem dev_boot_usb=1 dev_boot_signed_only=0 || echo -n
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

