
# aok Arch Linux for the Samsung XE303C12
aok as in A-okay

## What is this?
A really easy way to get a real Operating System on your Chromebook.
- Fully automated. Easy for a beginner.
- Pre-patched: 2D Graphics acceleration, Audio, Caps Lock, Bluetooth, WiFi, and more!
- Clean Xfce environment out of the box, ready to use.

## Enable Developer Mode
1. Back up your files.
2. Turn off the laptop.
3. To invoke Recovery mode, you hold down the ESC and Refresh keys and poke the Power button.
4. At the Recovery screen press Ctrl-D (there's no prompt - you have to know to do it).
5. Confirm switching to developer mode by pressing enter, and the laptop will reboot and reset the system. This takes about 15-20 minutes.

Note: After enabling developer mode, you will need to press Ctrl-D each time you boot, or wait 30 seconds to continue booting.

Pro Tip: You can press Ctrl-D (or Ctrl-U to boot from SD Card) as soon as the backlight comes on. You don't have to wait for the white screen to appear.


## Installation Guide
Minimum Requirements: 4 GB or larger SD Card. USB's won't work.

Recommended: 8 GB or larger SD Card.

Developer Mode must be enabled already.

1. Download Zip
2. Unzip by opening aok-master.zip and dragging aok-master to Downloads
3. Press CTRL+ALT+T for a crosh window
4. Type `shell` and press enter
5. Type `sudo install -Dt /usr/local/bin ~/Downloads/aok-master/aok` and press enter
6. Type `sudo aok` and press enter (and DON'T click on Chrome OS pop-up messages when they appear!)
7. Follow the instructions. (Reboot, login, and type `setup` to set it all up!)

## Notes

When you get online for the first time using "wifi-menu"...
If the Wi-Fi Hotspot has a Landing Page, see the WiFi Hotspot Help file in "extra".
Once the system is installed, Landing Pages will work automatically.

You may want to customize:
  - Your locale
  - Your own username
  - Your own hostname

IF YOU MODIFY THE USERNAME, YOU WILL HAVE TO MODIFY THE OTHER SCRIPT TO MATCH IT!!!

You probably REALLY want to run the "patch" stuff!!!
The patch code get Arch Linux working nicely on the XE303C12.
Everything else is just normal Arch Linux install stuff.

In rare cases, if the battery is discharged completely, it may not remember to allow you to boot from the SD Card. If Chrome OS is installed on the eMMC (internal memory), then it may 'repair itself' and erase everything from the internal memory, and require logging in to Google's servers and starting as if from a new system, all before you can get back to developer mode and enable booting from SD Card.

Also, if Chrome OS is on the eMMC, there have been seemingly random times when it
assumes there is an issue and attempts to repair itself. I'm not exactly sure what
causes this, but again, it may erase everything within Chrome OS and start over.
So it would be a good idea to back up any important files from Chrome OS, and
generally not trusting Chrome OS to save any of your local files for you.

## Thanks
The upstream source for this distribution comes to you from archlinuxarm.org.
https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook
