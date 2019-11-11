#!/bin/bash -ev

## USE ONLY UNTIL "networkmanager" IS INSTALLED
sudo wifi-menu

## INSTALL "networkmanager", GUI INTERFACE, AND SYSTRAY ICON
sudo pacman -S networkmanager nm-connection-editor network-manager-applet

## ENABLE "networkmanager" ON BOOT
sudo systemctl enable NetworkManager.service

## DO NOT START NetworkManager.service WITH wifi-menu RUNNING
## BECAUSE THEN THE SYSTEM WOULD HANG WHEN TRYING TO SHUT DOWN/REBOOT
## AND THE CHROMEBOOK MIGHT THINK IT NEEDS TO REPAIR ITSELF
## IN THAT CASE, DON'T LET IT DO ANYTHING, JUST HOLD POWER TO TURN OFF



### DEPRECATED METHOD: WICD

## INSTALL WICD
# sudo pacman -S wicd wicd-gtk

## RUN WICD ONCE, NOW
# sudo wicd

## ENABLE WIFI STARTING ON BOOT-UP
# sudo systemctl enable wicd.service
