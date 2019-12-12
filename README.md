# AOK Linux for ARMv7 Chromebooks

(https://raw.githubusercontent.com/cubetronic/aok/master/files/arch_linux_gnome_menu_icon_by_byamato.png "Arch Linux")

## Instructions
1. Enable Developer Mode
1. Insert an SD Card or USB Drive
1. Download [The AOK Script](https://www.dropbox.com/s/ahhk0cvjjavfqi4/aok?dl=1 "Get it from Dropbox")
3. Press CTRL+ALT+T for a crosh window
4. Type `shell` and press enter
5. Type `sudo install -Dt /usr/local/bin ~/Downloads/aok` and press enter
6. Type `aok` and press enter

## What is this?
- A User-Friendly Linux Distro for certain ARMv7 laptops, based one Arch Linux ARM and Xfce.
- The **easiest** and **fastest** way to get a full Linux Distro on an old Chromebook.
- AOK Linux is a set of scripts with a few extra files. Packages are from archlinuxarm.org.

## Features
- Fully automated. Easy for a beginner.
- Mirror checking for improved 24/7 reliability.
- Pre-configured: 2D Graphics acceleration, Audio enabled, Caps Lock setup, WiFi hotspots compatible, etc.
- Clean Xfce environment with Firefox out of the box, ready to use.

## Compatible Chromebook
- Samsung Chromebook (XE303C12)

## Possibly Compatible Chromebooks
- HP Chromebook 11 G1
- Samsung Chromebook 2 13 (XE503C32)
- Samsung Chromebook 2 11 (XE503C12)
- Haier Chromebook 11
- Medion Akoya S2013
- True IDC Chromebook 11
- Xolo Chromebook
- CTL J2 / J4 Chromebook for Education
- eduGear Chromebook K Series
- Epik 11.6" Chromebook ELB1101
- HiSense Chromebook 11
- Mecer Chromebook
- NComputing Chromebook CX100
- Poin2 Chromebook 11
- Positivo Chromebook CH1190
- VideoNet Chromebook BL10
- ASUS Chromebit CS10
- ASUS Chromebook Flip C100P
- ASUS Chromebook C201PA
- Acer Chromebook 13 (CB5-311)
- HP Chromebook 14 x000-x999 / HP Chromebook 14 G3

## Minimum Requirements
- A Compatible Chromebook
- 4 GB or larger SD Card or USB Drive
- Internet

## How to Enable Developer Mode
1. Back up your files.
2. Turn off the Chromebook.
3. Hold down the **ESC** and **Refresh** keys and poke the **Power** button.
4. At the Recovery screen press **Ctrl-D** (there's no prompt - you have to know to do it).
5. Confirm switching to developer mode by pressing **Enter**, and the laptop will reboot and reset the system. This takes about 15-20 minutes.

After enabling developer mode, you will need to press Ctrl-D each time you boot, or wait 30 seconds to continue booting.

## Post-Installation Tips
- You can press Ctrl-D or Ctrl-U as soon as the backlight comes on. You don't have to wait for the white screen to appear.
- For help using Arch Linux, visit https://wiki.archlinux.org/

## Known Issues
Issues common to open source linux distributions on the Samsung Chromebook XE303C12
- Suspend
- USB 3.0
- Camera
- 3D Acceleration not yet supported (But definitely possible now due to recent (2019) updates in the Linux Kernel)

## Notes
If you need to use a public Wi-Fi Hotspot with a Landing Page during setup, then see the WiFi Hotspot Help file in "extra".
Once the system is installed, Landing Pages will work automatically.

The default locale is English, US. You may want to customize the setup script to use your locale.

If you want to copy files from ChromeOS, then after booting from SD/USB, only mount the eMMC read-only without loading the journaling system, for example:  
`sudo mount -o ro,noload /dev/mmcblk0p1 /mnt` Mounting the eMMC in any other way may cause Chrome OS to "repair itself" upon next boot, ERASING ALL USER DATA ON THE eMMC. If you want to copy files from AOK Linux to ChromeOS, then on ChromeOS do this:  
```
mkdir -p /usr/local/mount
sudo mount -o noload /dev/mmcblk1 /usr/local/mount
```
replace `mmcblk1` with `sda` for a USB or `sdb` for a second USB

In rare cases, if the battery is discharged completely for a long period of time, the Chromebook boot system may not remember to allow you to boot from the SD Card or USB. If Chrome OS is installed on the eMMC (internal memory), then it may "repair itself" and erase everything from the internal memory, and require logging in to Google's servers and starting as if from a new system, all before you can get back to developer mode and re-enable booting from the SD Card or USB. This does not affect the integrity of the SD Card or USB, or your files on the SD Card or USB.

## Thanks
The upstream source for this distribution comes to you from archlinuxarm.org.

https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook
