#!/bin/bash -ev

## DEPENDS: files/locale.gen
## RUN THIS SCRIPT FIRST AFTER LOGGING IN TO NEW INSTALLATION

## STOP KERNEL MESSAGES FROM GARBLING CONSOLE
dmesg -n 1

## REMOVE DEFAULT ALARM ACCOUNT, SET ROOT PASSWORD
userdel -r alarm
passwd

## LOCALE
## NOTICE: CAPS LOCK KEY FIX MAY OVERRIDE SETTINGS: US ONLY

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
passwd a

## disable systemd-resolved managment of dns because it breaks landing pages
systemctl disable systemd-resolved.service

## Put a classic resolv.conf file in place, instead of what is now a broken link
rm /etc/resolv.conf
echo "nameserver 1.1.1.1" > /etc/resolv.conf

## MANUAL WIFI CONFIGURATION
wifi-menu

## UNCOMMENT CLOSEST MIRROR, COMMENT MAIN
nano /etc/pacman.d/mirrorlist

## INITIALIZE PACKAGE MANAGER
pacman-key --init
pacman-key --populate archlinuxarm

## NOTICE: UPGRADING PACKAGES MAY REQUIRE MORE THAN THE AVAILABLE SPACE
pacman --noconfirm -Sy sudo

## Append wheel group line to /etc/sudoers file through visudo
## This allows root privilege to users who are members of the wheel group
echo -e '\n# Allow members of group wheel to execute any command\n%wheel\tALL=(ALL:ALL) ALL' | EDITOR='tee -a' visudo

## CHOICE
echo "upgrade packages now with 'pacman -Syu', and reboot..."
echo "or continue to next script"

## REBOOT TO LOAD UPGRADED KERNEL, ETC
# reboot


