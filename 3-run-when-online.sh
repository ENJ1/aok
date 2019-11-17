#!/bin/bash -e

## Run 'wifi-menu' before running this, so you can get online

## Optionally, you can choose a closer mirror for faster downloads.
## Sometimes the main mirror doesn't work, so this may be necessary.
#nano /etc/pacman.d/mirrorlist

###########################################################################
## UPGRADE AND INSTALL PACKAGES
##
## Sync repo, upgrade, and install packages without hassle
##
## sudo: needed to gain root privilege
## xf86-video-fbdev: needed for Mali-T604 Graphics acceleration patch below
## alsa-utils: needed for auto (patch below); to unmute audio and keep unmuted
## xorg-server: needed for Xfce. chromebook caps (patch below)
## ttf-dejavu: basic font pack
## xterm: needed for volumeicon, and recommended for volumeicon because the window is small
## firefox: needed for landing page redirection for public Wi-Fi Hotspots
## unzip: basic utility
## zip: basic utility
## xarchiver: gui frontend for tar, zip, gzip, xz, etc.
## volumeicon: volume gui. depends on xterm by default but won't automatically install it
## xfce4: Desktop Environment and all associated packages (gui config will be on desktop)
## xorg-xinit: start Xfce from command line (configured below)
## lightdm: autostart Xfce on bootup (enabled below)
## lightdm-gtk-greeter: login screen
## networkmanager: networking backend (enabled below)
## nm-connection-editor: networking editor gui
## network-manager-applet: tray icon
## blueman: bluetooth utility and frontend
## gpicview: lightweight image viewer
## mousepad: lightweight text editor and code syntax highlighter made for Xfce
## xorg-xinput: command line mouse and trackpad control (script included in extra)
## cgpt: for creating partition flags for chromebooks (used by install script)
## mplayer: install a video player that actually works. vlc is too heavy.
## cheese: webcam video capture
##
pacman -Syu --noconfirm sudo xf86-video-fbdev alsa-utils xorg-server ttf-dejavu xterm \
firefox unzip zip xarchiver volumeicon xfce4 xorg-xinit lightdm lightdm-gtk-greeter \
networkmanager nm-connection-editor network-manager-applet blueman gpicview mousepad \
xorg-xinput cgpt mplayer cheese
###########################################################################

###########################################################################
## VIDEO PATCH
##
## DEPENDS ON: xf86-video-fbdev
##
## Create configuration file to implement graphics acceleration
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
## With this driver setup, the Xorg Server needs root privilege
echo "needs_root_rights = yes" > /etc/X11/Xwrapper.config
###########################################################################

###########################################################################
## AUDIO PATCH
##
## DEPENDS ON: alsa-utils
##
## UNMUTE. TO UNMUTE MANUALLY, RUN "alsamixer",
## USE RIGHT ARROW, AND PRESS "m" TO UNMUTE THE FOLLOWING:
amixer -c 0 set 'Left Headphone Mixer Left DAC1' on
amixer -c 0 set 'Right Headphone Mixer Right DAC1' on
amixer -c 0 set 'Left Speaker Mixer Left DAC1' on
amixer -c 0 set 'Right Speaker Mixer Right DAC1' on
## DOES A MICROPHONE NEED TO BE UNMUTED?
##
## SET VOLUME (DEFAULT IS ZERO)
amixer -c 0 set Headphone 70%
amixer -c 0 set Speaker 70%
##
## PLUGGING-IN/UNPLUGGING HEADPHONES WILL NOT MUTE/UNMUTE THE SPEAKER
## THIS MUST BE CONTROLLED MANUALLY BY THE USER
##
## SAVE SETTINGS AFTER UNMUTING HEADPHONES AND SPEAKER
## THIS ALSO CREATES A FILE SO THAT CHANGES ALWAYS PERSIST ACROSS REBOOTS
## SO THIS ONLY NEEDS TO BE RUN ONCE
alsactl store
##
## CREATE AUDIO CONFIGURATION FILE
## THIS ALLOWS MULTIPLE SOUND STREAMS AT THE SAME TIME
## The "a" in asound.conf stands for alsa, and is not specific to this setup
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
###########################################################################


## Configure sudo
## Append wheel group line to /etc/sudoers file through visudo.
## This allows root privilege to users who are members of the wheel group
## This is an easy way to automate this but a cheap solution, because
## a similar line already exists in the file but is commented out, and
## because if this script is run again, this will be appended again.
## Should probably use sed, or just copy a new file in without depending
## on getting sudo, but does installing sudo overwrite the sudoers file?
echo -e '\n# Allow members of group wheel to execute any command\n%wheel\tALL=(ALL:ALL) ALL' | EDITOR='tee -a' visudo


###########################################################################
## CAPS LOCK PATCH (FOR WINDOW ENVIRONMENT NOT CONSOLE)
##
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
###########################################################################


## Configure being able to run "startx" to load Xfce
echo "exec startxfce4" > /home/a/.xinitrc
chown a:a /home/a/.xinitrc

## Enable lightdm to load Xfce on boot
systemctl enable lightdm

## Enable WiFi gui autostart now that lightdm is autostarting Xfce
systemctl enable NetworkManager
## DO NOT START NetworkManager.service WITH wifi-menu RUNNING
## BECAUSE THEN THE SYSTEM WOULD HANG WHEN TRYING TO SHUT DOWN/REBOOT
## AND THEN CHROME OS MIGHT THINK IT NEEDS TO REPAIR ITSELF
## IN THAT CASE, DON'T LET IT DO ANYTHING, JUST HOLD POWER TO TURN OFF
## AND IT SHOULD BE FINE
##
### DEPRECATED NETWORKING UTILITY: WICD
## INSTALL WICD
# sudo pacman -S wicd wicd-gtk
## RUN WICD ONCE, NOW
# sudo wicd
## ENABLE WIFI STARTING ON BOOT-UP
# sudo systemctl enable wicd

# Enable Bluetooth
systemctl enable bluetooth



################################################################
## OPTIONAL PACKAGES
################################################################

## Command line browsers
##
# sudo pacman -S links
# sudo pacman -S lynx

## AUDIO
##
## deadbeef: minimal yet full featured audio player
## audacity: powerful audio editor and converter (add-ons not installed)
## lmms: linux multimedia music studio for loops (not a DAW)
##
# pacman -Sy deadbeef audacity lmms

## TORRENTING
# sudo pacman -S deluge

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
##
## vlc is not recommended because it is too heavy. it won't work well.
## if you must try it, it depends on qt4 but qt4 is not installed automatically.
# sudo pacman -S vlc qt4

## DEVELOPMENT PACKAGES
## base-devel: INCLUDES gcc AND make WHICH ARE NECESSARY FOR YAOURT
## x264: FOR VIDEO
## lshw: FOR LISTING HARDWARE
## hardinfo: FOR BROWSING KERNEL MODULES
# sudo pacman -S base-devel x264 lshw hardinfo cmake gcc

## HEAVY PROGRAMS
##
## IMAGE EDITOR
## sudo pacman -S gimp
##
## OFFICE
## sudo pacman -S libreoffice

## Now that that's all done, remove install help from the root bashrc
cp /etc/skel/.bashrc /root

## Exit message
echo ""
echo "Done."
echo ""

## REBOOT TO LOAD UPGRADED KERNEL, ETC
read -p "Press enter to reboot"
reboot
