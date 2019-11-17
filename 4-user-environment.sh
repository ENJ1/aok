#!/bin/bash -ev

## DEPENDS: files/menu.xml
## DEPENDS: files/tint2rc
## DEPENDS: files/brightness.conf
## DEPENDS: files/b


## STOP KERNEL MESSAGES FROM INTERFERING WITH CONSOLE
sudo dmesg -n 1

## SYNC AND INSTALL BASICS
sudo pacman -Sy xorg-server ttf-dejavu xterm leafpad
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



# sudo pacman -S openbox xorg-xinit
# echo "exec openbox" > /home/a/.xinitrc
# chown a:a /home/a/.xinitrc

## BROWSER
# sudo pacman -S links
# sudo pacman -S lynx
sudo pacman -S firefox

## COMPRESSION UTILITIES
sudo pacman -S unzip zip xarchiver

## XFCE
sudo pacman -S xfce4 xorg-xinit
echo "exec startxfce4" > /home/a/.xinitrc
chown a:a /home/a/.xinitrc

## INSTALL lightdm AND ENABLE
sudo pacman -S lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm

## Enable WiFi gui autostart now that lightdm is autostarting
################################################################
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
################################################################





## ESSENTIAL AUDIO
sudo pacman -S volumeicon xterm

## ESSENTIAL IMAGE
sudo pacman -S gpicview

## AUDIO
# pacman -S deadbeef audacity lmms



#################### OPENBOX ENVIRONMENT ###################

## menu.xml IS CURRENTLY  CONFIGURED TO DEPEND ON THE FOLLOWING COMMANDS:
# firefox gmrun gedit terminator deluge deadbeef wicd-client thunar \
# tint2 leafpad obmenux obconf tint2conf xterm 

## OPENBOX AUTOSTART & MENU
# mkdir -p /home/a/.config/openbox/
# chown a:a /home/a/.config/
# chown a:a /home/a/.config/openbox/
# touch /home/a/.config/openbox/autostart
# chown a:a /home/a/.config/openbox/autostart
# cp files/menu.xml /home/a/.config/openbox/menu.xml
# chown a:a /home/a/.config/openbox/menu.xml

## BASIC CUT/COPY/PASTE FUNCTIONALITY WITHOUT A DESKTOP ENVIRONMENT
# sudo pacman -S parcellite

## BASIC IMAGE VIEWER, PROGRAM RUNNER, SCREENSHOT
# sudo pacman -S feh gmrun scrot

## DESKTOP
# sudo pacman -S xfdesktop

## GUI FILE MANAGER
# sudo pacman -S thunar
# sudo pacman -S pcmanfm

## TINT2
# sudo pacman -S tint2
# mkdir -p /home/a/.config/tint2/
# chown a:a /home/a/.config/tint2/
# cp files/tint2rc /home/a/.config/tint2/tint2rc
# chown a:a /home/a/.config/tint2/tint2rc

## THE GITHUB PROGRAM obmenux NEEDS pygtk
# sudo pacman -S pygtk
# sudo pacman -S obconf

#########################################################





### OPTIONAL PACKAGES

## TORRENTING
# sudo pacman -S deluge

## COMMAND LINE TOUCHPAD AND MOUSE CONTROL AND FINE TUNING
# sudo pacman -S xorg-xinput

## COMMAND LINE DOWNLOAD UTILITY (OTHER THAN CURL)
# sudo pacman -S wget

## PDF
## sudo pacman -S evince

## ANDROID FILE TRANSFER
# sudo pacman -S android-file-transfer

## CALCULATOR
# sudo pacman -S galculator
# sudo pacman -S speedcrunch

## VIDEO
## VLC VIDEO ON THIS LAPTOP WITHOUT FULL MALI-T604 SUPPORT IS NOT RECOMMENDED
## PARTIAL MALI-T604 SUPPORT FROM xf86-video-fbdev WITH CONFIG FILES WILL
## ALLOW BASIC VIDEO FUNCTIONALITY:
## YOUTUBE VIDEO WORKS
## AND x264 VIDEO WORKS (AT LEAST AT LOW RESOLUTIONS)
## x265 VIDEO IS KNOWN TO NOT WORK WITHOUT FULL MALI-T604 SUPPORT
## vlc NEEDS qt4, BUT IT DOESN'T GET INSTALLED AUTOMATICALLY
# sudo pacman -S vlc qt4

## DEVELOPMENT PACKAGES
## base-devel INCLUDES gcc AND make WHICH ARE NECESSARY FOR YAOURT
## x264 FOR VIDEO
## lshw FOR LISTING HARDWARE
## hardinfo FOR BROWSING KERNEL MODULES
## cgpt for creating partition flags for chromebooks
# sudo pacman -S cgpt base-devel x264 lshw hardinfo cmake gcc




## LARGE PROGRAMS

## IMAGE
## sudo pacman -S gimp

## OFFICE
## sudo pacman -S libreoffice


