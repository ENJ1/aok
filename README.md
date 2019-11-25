
# Arch Linux on the Samsung XE303C12
## Installation Guide
Minimum Requirements: 4 GB or larger SD Card. USB's won't work.

Recommended: 8 GB or larger SD Card.

Developer Mode must be enabled already.

1. Download Zip
2. Unzip by opening aok-master.zip and dragging aok-master to Downloads
3. Press CTRL+ALT+T for a crosh window
4. Type `shell` and press enter
5. Type `sudo install -Dt /usr/local/bin ~/Downloads/aok-master/aok` and press enter
6. Type `sudo aok` and press enter
7. Follow instructions

# Notes

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

The could be an issue if the battery is discharged completely.
It may not remember to allow you to boot from the SD Card.
If Chrome OS is installed on the eMMC (internal memory), then it may 'repair itself'
and erase everything from the internal memory, and require logging in to Google's
servers and starting as if from a new system.
I'm not sure exactly what all the details are. Just try to avoid letting the battery
discharge completely.
Also, if Chrome OS is on the eMMC, there have been seemingly random times when it
assumes there is an issue and attempts to repair itself. I'm not exactly sure what
causes this, but again, it may erase everything within Chrome OS and start over.
So it would be a good idea to back up any important files from Chrome OS, and
generally not trusting Chrome OS to save any of your local files for you.
