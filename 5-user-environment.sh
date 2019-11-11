#!/bin/bash -ev

## DEPENDS: files/menu.xml
## DEPENDS: files/tint2rc
## DEPENDS: files/brightness.conf
## DEPENDS: files/b


## STOP KERNEL MESSAGES FROM INTERFERING WITH CONSOLE
sudo dmesg -n 1

## SYNC AND INSTALL BASICS
sudo pacman -Sy xorg-server ttf-dejavu xterm leafpad

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
sudo systemctl enable lightdm.service

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


