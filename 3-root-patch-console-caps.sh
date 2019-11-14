#!/bin/bash -ev

## FIX CAPS LOCK KEY FOR CONSOLE (NOT XORG)
## TO CUSTOMIZE, REPLACE "us" WITH YOUR LAYOUT
## BUT DO NOT ECHO IT TO vconsole.conf UNTIL YOU ARE SURE IT WORKS
cp /usr/share/kbd/keymaps/i386/qwerty/us.map.gz /usr/share/kbd/keymaps/us-chrome-caps.map.gz
gunzip /usr/share/kbd/keymaps/us-chrome-caps.map.gz
echo "keycode 125 = Caps_Lock" >> /usr/share/kbd/keymaps/us-chrome-caps.map
loadkeys /usr/share/kbd/keymaps/us-chrome-caps.map
echo "KEYMAP=us-chrome-caps" > /etc/vconsole.conf
