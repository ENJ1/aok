#!/bin/bash -ev

## FIX CAPS LOCK KEY FOR CONSOLE (NOT XORG)
## TO CUSTOMIZE, REPLACE "us" WITH YOUR LAYOUT
## BUT DO NOT ECHO IT TO vconsole.conf UNTIL YOU ARE SURE IT WORKS
cp /usr/share/kbd/keymaps/i386/qwerty/us.map.gz /usr/share/kbd/keymaps/us-chrome-caps.map.gz
gunzip /usr/share/kbd/keymaps/us-chrome-caps.map.gz
echo "keycode 125 = Caps_Lock" >> /usr/share/kbd/keymaps/us-chrome-caps.map
loadkeys /usr/local/share/kbd/keymaps/us-chrome-caps.map
echo "KEYMAP=us-chrome-caps" > /etc/vconsole.conf


## FIX CAPS LOCK KEY FOR XORG X11 WINDOWING (NOT CONSOLE)
## THIS WILL PROVIDE CAPS LOCK GLOBALLY, FOR ALL USERS, EVEN AT LOGIN.
## THIS CHANGES THE CONFIGURATION FOR "Generic 105-key PC (intl.)" AND
## OTHER GENERIC KEYBOARDS. IF YOU INSTEAD CHOOSE A CHROMEBOOK KEYBOARD
## IN THE LAYOUT SETTINGS OF YOUR DESKTOP ENVIRONMENT, THEN YOU
## WILL GET THE TRUE CHROMEBOOK EXPERIENCE: NO CAPS LOCK.

## Backup the original keyboard configuration file
cp -n /usr/share/X11/xkb/symbols/pc /usr/share/X11/xkb/symbols/pc.bak

## Create a new custom file
sed 's/key <LWIN> {\t\[ Super_L/key <LWIN> {\t\[ Caps_Lock/g' \
/usr/share/X11/xkb/symbols/pc > /usr/share/X11/xkb/symbols/pc-chrome-caps

## Overwrite the old file with the new custom file
cp /usr/share/X11/xkb/symbols/pc-chrome-caps /usr/share/X11/xkb/symbols/pc

## You must reboot for changes to take effect
#reboot

## You can restore the original file at any time
#cp /usr/share/X11/xkb/symbols/pc.bak /usr/share/X11/xkb/symbols/pc



## X11 CAPS LOCK, PER USER, PER SESSION: THE SIMPLE WAY

## Alternatively, you could just run the following command, but you would have
## to run it upon every login, for every user.
#xmodmap -e "keycode 133 = Caps_Lock"

## To load it on X11 login every time for that user...
## (This may not work for the root user, and may not work for all systems)
#echo "keycode 133 = Caps_Lock" > ~/.Xmodmap




