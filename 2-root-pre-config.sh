#!/bin/bash -e

## Run this script first upon logging into a new installation

## This script depends on files/locale.gen

## Stop kernel messages from garbling the command line
dmesg -n 1

## Remove the default alarm (Arch Linux ARM) account.
## This account is only needed if you have to use SSH to login remotely
## for the very first login, which is not applicable here.
userdel -r alarm

## Fix Caps Lock for the Virtual Console.
## (The real console, without any Window Environment)
##
## These changes do not effect Caps Lock in a Window Environment,
## and do not effect consoles run while in a Window Environment.
##
## If you have a non-US keyboard layout, replace "us" with your keyboard type,
## but do not echo it to vconsole.conf until you are sure it works.
## Using loadkeys is safe for testing. It takes effect immediately,
## but does not apply permanent changes across reboots.
cp /usr/share/kbd/keymaps/i386/qwerty/us.map.gz /usr/share/kbd/keymaps/us-chrome-caps.map.gz
gunzip /usr/share/kbd/keymaps/us-chrome-caps.map.gz
echo "keycode 125 = Caps_Lock" >> /usr/share/kbd/keymaps/us-chrome-caps.map
loadkeys /usr/share/kbd/keymaps/us-chrome-caps.map
echo "KEYMAP=us-chrome-caps" > /etc/vconsole.conf
#echo "The Search Key is now Caps Lock"
#echo "Caps Lock is OFF"

## Change root password
echo "Enter a new root password"
passwd

## Set time zone to Pacific
#ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

## Let anyone set the time zone
tzselect

## Standard Arch Linux Recommendation, perhaps not necessary or needed
hwclock --systohc

## nano /etc/locale.gen AND UNCOMMENT LOCALE, OR USE PREMADE FILE
install -o root -g root -m 0644 files/locale.gen /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

## AOK SYSTEM CONFIGURATION
echo "ok" > /etc/hostname
cat << EOF > /etc/hosts
127.0.0.1	localhost
::1		localhost
127.0.1.1	ok.localdomain	ok
EOF
useradd -m -G wheel -s /bin/bash a

## Change password for the "a" account
echo 'The default user account is just the letter "a"'
echo 'Enter a new password for the "a" account'
passwd a

## Disable systemd-resolved DNS managment because it breaks Wi-Fi hotspot landing pages
systemctl disable systemd-resolved.service

## Put a classic resolv.conf file in place, instead of what is now a broken link
rm /etc/resolv.conf
echo "nameserver 1.1.1.1" > /etc/resolv.conf

## MANUAL WIFI CONFIGURATION
wifi-menu

## UNCOMMENT CLOSEST MIRROR, COMMENT MAIN
#nano /etc/pacman.d/mirrorlist

## INITIALIZE PACKAGE MANAGER
pacman-key --init
pacman-key --populate archlinuxarm

## Get sudo
pacman --noconfirm -Sy sudo

## Append wheel group line to /etc/sudoers file through visudo.
## This allows root privilege to users who are members of the wheel group
## This is an easy way to automate this but a cheap solution, because
## a similar line already exists in the file but is commented out, and
## because if this script is run again, this will be appended again.
## Should probably use sed, or just copy a new file in without depending
## on getting sudo, but does installing sudo overwrite the sudoers file?
echo -e '\n# Allow members of group wheel to execute any command\n%wheel\tALL=(ALL:ALL) ALL' | EDITOR='tee -a' visudo

## Exit message
echo -e "\nIf you need to do advanced network administration, do that now.\n"
echo "Otherwise, now is a good time to upgrade the system."
echo "NOTICE: UPGRADING PACKAGES MAY REQUIRE MORE THAN THE AVAILABLE SPACE"
echo "You may upgrade packages now with 'pacman -Syu', then 'reboot' when it is done."
echo "Or you may skip this, and continue to the next script"

## REBOOT TO LOAD UPGRADED KERNEL, ETC
# reboot
