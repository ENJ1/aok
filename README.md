**DECEMBER 8, 2019 UPDATE:**  
Although the December 3, 2019 Arch Linux ARM release **does not** have wifi-menu,  
AOK Linux **does** have wifi-menu pre-installed by default, making to easy to get online.  


# AOK Linux for the XE303C12 Chromebook
Pronounced "A-okay"

## What is this?
A really easy way to get a real Operating System on your Chromebook. It's a set of scripts with a few files.
- Fully automated. Easy for a beginner.
- Pre-configured: 2D Graphics acceleration, Audio, Caps Lock, WiFi, etc.
- Clean Xfce environment with Firefox out of the box, ready to use.

## Supported Chromebooks
- Samsung XE303C12
- HP Chromebook 11 G1
- and more, see Wiki

## Enable Developer Mode
1. Back up your files.
2. Turn off the laptop.
3. To invoke Recovery mode, you hold down the ESC and Refresh keys and poke the Power button.
4. At the Recovery screen press Ctrl-D (there's no prompt - you have to know to do it).
5. Confirm switching to developer mode by pressing enter, and the laptop will reboot and reset the system. This takes about 15-20 minutes.

Note: After enabling developer mode, you will need to press Ctrl-D each time you boot, or wait 30 seconds to continue booting.

Pro Tip: You can press Ctrl-D (or Ctrl-U to boot from SD Card) as soon as the backlight comes on. You don't have to wait for the white screen to appear.


## Installation Guide
Requirements:
- A Chromebook: Sumsung XE303C12 or HP Chromebook 11 G1
- Developer Mode enabled
- 4 GB or larger SD Card, or a Sandisk SDCZ430-032G USB Flash drive*. The final install size is 2.9 GB
- Internet (to download about 850 MB)

1. Download the Zip (green button)
2. Unzip by opening aok-master.zip and dragging aok-master to Downloads
3. Press CTRL+ALT+T for a crosh window
4. Type `shell` and press enter
5. Type `sudo install -Dt /usr/local/bin ~/Downloads/aok-master/aok` and press enter
6. Type `sudo aok` and press enter (and DON'T click on Chrome OS pop-up messages when they appear!)
7. Follow the instructions. (Reboot, login, and type `setup` to set it all up!)

\* This USB Flash Drive is known to work. Many USB Flash drives do not work. 

## Post-Installation Tips
- To free up a lot of space (about 500 MB), run Terminal Emulator and type `sudo pacman -Scc`
- To update the package list, run Terminal Emulator and type `sudo pacman -Sy`
- To install a program (package), run Terminal Emulator and type `sudo pacman -S thunderbird` for example
- For help using Arch Linux, visit https://wiki.archlinux.org/

## Notes

If you need to use a public Wi-Fi Hotspot with a Landing Page during setup, then see the WiFi Hotspot Help file in "extra".
Once the system is installed, Landing Pages will work automatically.

You may want to customize the scripts to use:
  - Your locale
  - Your own username
  - Your own hostname

You probably REALLY want to run the "pre-config" stuff!!!
The patch code get Arch Linux working nicely on the XE303C12.
Everything else is just normal Arch Linux install stuff.

After booting from SD/USB, only mount the eMMC read-only without loading the journaling system: `mount -o ro,noload /dev/mmcblk0pY /mnt` where `Y` is a partition number and `/mnt` is the folder you want to mount it to. Mounting the eMMC in any other way may cause Chrome OS to "repair itself" upon next boot, ERASING ALL USER DATA ON THE eMMC.

It might be true that in rare cases, if the battery is discharged completely for a long period of time, the Chromebook boot system may not remember to allow you to boot from the SD Card. If Chrome OS is installed on the eMMC (internal memory), then it may "repair itself" and erase everything from the internal memory, and require logging in to Google's servers and starting as if from a new system, all before you can get back to developer mode and re-enable booting from the SD Card. This does not affect the integrity of the SD Card or your files on the SD Card.

## Thanks
The upstream source for this distribution comes to you from archlinuxarm.org.

https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook
