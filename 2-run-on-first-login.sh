#!/bin/bash -e

## Run this script first upon logging into a new installation

## This script depends on files/locale.gen

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
cp /usr/share/kbd/keymaps/i386/qwerty/us.map.gz \
    /usr/share/kbd/keymaps/us-chrome-caps.map.gz
gunzip /usr/share/kbd/keymaps/us-chrome-caps.map.gz
echo "keycode 125 = Caps_Lock" >> /usr/share/kbd/keymaps/us-chrome-caps.map
loadkeys /usr/share/kbd/keymaps/us-chrome-caps.map
echo "KEYMAP=us-chrome-caps" > /etc/vconsole.conf
echo "The Search Key is now Caps Lock"
echo "Caps Lock is OFF"

## Change root password
echo
echo "Enter a new root password"
passwd

## Set the time zone interactively
TIMEZONE=`tzselect`
ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

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

## Disable systemd-resolved DNS managment because it breaks Wi-Fi hotspot
## landing pages
systemctl disable systemd-resolved

## Put a classic resolv.conf file in place, instead of what is now a broken link
rm /etc/resolv.conf
echo "nameserver 1.1.1.1" > /etc/resolv.conf

## INITIALIZE PACKAGE MANAGER
pacman-key --init
pacman-key --populate archlinuxarm

echo
echo "The offline setup is complete."
echo 'If you can't get online now, press q, and press enter'
echo 'then type "poweroff" to shut down'
echo
echo "Otherwise, just press enter to run wifi-menu."
read -p "> " QUIT

case "$QUIT" in
  q|Q)
    echo 'Type "./3-run-when-online.sh" and press enter to complete setup.'
    echo 'Type "poweroff" to shut down'
    echo 'Type "reboot" to boot to a differenet device'
    exit 1
    ;;
  *)
    wifi-menu
    ;;
esac

## Running pacman right after wifi-menu leads to issues, so sleep for a few seconds
echo "Preparing for network activity..."
sleep 5
./3-run-when-online.sh
