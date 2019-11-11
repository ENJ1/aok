#!/bin/bash -ev

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









