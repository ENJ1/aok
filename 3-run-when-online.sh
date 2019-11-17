#!/bin/bash -ev

## Run 'wifi-menu' before running this, so you can get online

## Optionally, you can choose a closer mirror for faster downloads.
## Sometimes the main mirror just doesn't work, so this might actually
## be necessary.
#nano /etc/pacman.d/mirrorlist

## DOWNLOAD DRIVER FOR PARTIAL MALI-T604 SUPPORT
pacman -Sy --noconfirm xf86-video-fbdev
## CREATE xf86-video-fbdev CONFIG FILE FOR PARTIAL MALI-T604 SUPPORT
## MUST DOWNLOAD xf86-video-fbdev PACKAGE FOR THIS TO MAKE A DIFFERENCE
mkdir -p /etc/X11/xorg.conf.d/

cat << EOF > /etc/X11/xorg.conf.d/10-monitor.conf
Section	"Device"
	Identifier	"Mali FBDEV"
	Driver		"fbdev"
	Option		"fbdev"			"/dev/fb0"
	Option		"Fimg2Dexa"		"false"
	Option		"DRI2"			"true"
	Option		"DRI2_PAGE_FLIP"	"false"
	Option		"DRI2_WAIT_VSYNC"	"true"
	Option		"SWcursorLCD"		"false"
EndSection

Section	"Screen"
	Identifier	"DefaultScreen"
	Device		"Mali FBDEV"
	DefaultDepth	24
EndSection
EOF

## WITH THIS DRIVER SETUP, THE XORG SERVER NEEDS ROOT PRIVILEGE
echo "needs_root_rights = yes" > /etc/X11/Xwrapper.config



## TO ENABLE AUDIO WE WILL USE alsa-utils
pacman -S alsa-utils

## UNMUTE. TO DO MANUALLY, RUN "alsamixer",
## USE RIGHT ARROW, AND PRESS "m" TO UNMUTE THE FOLLOWING:
amixer -c 0 set 'Left Headphone Mixer Left DAC1' on
amixer -c 0 set 'Right Headphone Mixer Right DAC1' on
amixer -c 0 set 'Left Speaker Mixer Left DAC1' on
amixer -c 0 set 'Right Speaker Mixer Right DAC1' on
## DOES A MICROPHONE NEED TO BE UNMUTED?

# SET VOLUME (DEFAULT IS ZERO)
amixer -c 0 set Headphone 70%
amixer -c 0 set Speaker 70%
## PLUGGING-IN/UNPLUGGING HEADPHONES WILL NOT MUTE/UNMUTE THE SPEAKER
## THIS MUST BE CONTROLLED MANUALLY BY THE USER

## SAVE SETTINGS AFTER UNMUTING HEADPHONES AND SPEAKER
## THIS ALSO CREATES A FILE SO THAT CHANGES ALWAYS PERSIST ACROSS REBOOTS
alsactl store

## CREATE AUDIO CONFIGURATION FILE
## THIS ALLOWS MULTIPLE SOUND STREAMS AT THE SAME TIME
cat << EOF > /etc/asound.conf
pcm.!default {
              type plug
              slave.pcm "dmixer"
}
pcm.dmixer  {
            type dmix
        ipc_key 1024
        slave {
          pcm "hw:0,0"
          period_time 0
              period_size 1024
          buffer_size 4096
          rate 44100
        }
        bindings {
          0 0
          1 1
        }
}
ctl.dmixer {
       type hw
       card 0
}
EOF

## OPTIONAL MINIMAL PACKAGES FOR IMPROVED CONTROL
## volumeicon DEPENDS ON xterm UNLESS OTHERWISE CONFIGURED
## xterm IS RECOMMENDED HERE BECAUSE THE WINDOW IS SMALL
# sudo pacman -S volumeicon xterm


## Get sudo, and configure
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
echo "Now is a good time to upgrade the system, if there is enough storage space"
echo "Run 'df -h' to view available space"
echo "You may upgrade packages now with 'pacman -Syu', then 'reboot' when it is done."
echo "Or you may skip this, and continue to the next script"

## REBOOT TO LOAD UPGRADED KERNEL, ETC
# reboot
