# AOK Linux for ARMv7 Chromebooks
The **easy** way to get ***Arch Linux, Xfce, Firefox, and more*** running on an old Chromebook

[![Download The AOK Script](https://raw.githubusercontent.com/cubetronic/aok/master/files/arch_linux_gnome_menu_icon_by_byamato.png)](https://www.dropbox.com/s/ahhk0cvjjavfqi4/aok?dl=1 "Download The AOK Script")

## Features
- Installing Arch Linux is fully automated. It's easy for a beginner. No Linux experience is required.
- A fast, minimalist Xfce Desktop Environment, ready for running the programs you want
- Firefox is pre-loaded with UBlock, User-Agent Switcher, and Kill Sticky Headers
- Pre-configured 2D Graphics acceleration, Audio enabled, Caps Lock setup, WiFi hotspots compatible, etc.
- Mirror checking for speed and improved 24/7 reliability.
- AOK Custom Command line utilities for advanced users: dim, spoof, and tpad

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
- 4 GB or larger SD Card or a [compatible USB Drive](https://github.com/cubetronic/aok/wiki#is-my-usb-flash-drive-bootable "Check the Wiki")
- Internet

## Instructions
If Developer Mode is already enabled, skip steps 1-5.  
To check if Developer Mode is enabled, you can try opening *crosh* and *bash* (see Step 5).

---

### Step 1
Back up your files. Turn off the Chromebook.  
![buttons](https://user-images.githubusercontent.com/11820866/70834287-c5e73380-1dae-11ea-88c2-fc9c7940bd91.png "The location of the ESC, Refresh (or F3), and Power Buttons")  
Hold **`esc`**+**`refresh`** and press **`power`**.

---

### Step 2
![missing](https://user-images.githubusercontent.com/11820866/70834349-f202b480-1dae-11ea-97f9-7a410f74ac9a.png "Screen shows 'Chrome OS is missing or damanged.'")  
Press **`ctrl`**+**`d`** when the screen says "Chrome OS is missing or damanged."

---

### Step 3
![enter](https://user-images.githubusercontent.com/11820866/70834851-435f7380-1db0-11ea-95ea-625e30a5c2a1.png "Screen shows 'To turn OS verification OFF, press ENTER.'")  
Press **`enter`** when the screen says "To turn OS verification OFF, press ENTER."

---

### Step 4
![verification](https://user-images.githubusercontent.com/11820866/70834971-8883a580-1db0-11ea-8ca1-d77cb3843cf2.png "Screen shows 'OS verification is OFF'")  
Press **`ctrl`**+**`d`** when the screen says "OS verification is OFF".  

**Never** press space. Doing so will disable Developer Mode.  

The secret options from this screen are:
- Wait 30 seconds - the computer will beep and boot from eMMC (Internal Storage)
- Press **`ctrl`**+**`d`** - immediately boot from eMMC (Internal Storage)
- Press **`ctrl`**+**`u`** - immediately boot from SD Card or USB Drive (External Storage)  

---

### Step 5
Chrome OS will walk you through a new installation of Chrome OS.  
You will be required to create or login with a Google account.  

When setting up the refreshed Chrome OS, you may see the option:
- *Enable Debugging Features* - This is not required, and doesn't work. Ignore it.

![shell](https://user-images.githubusercontent.com/11820866/70835504-2cba1c00-1db2-11ea-8fef-d82942d33e6a.png "Screen shows Chrome OS developer shell")  

When Chrome OS is done installing:
1. Press **`ctrl`**+**`alt`**+**`t`** for a *crosh* shell.
2. Type `shell` for a *bash* shell.

Congratulations! You are now using Developer Mode.

---

### Step 6
Insert an SD Card or USB Drive.

### Step 7
Download [The AOK Script](https://www.dropbox.com/s/ahhk0cvjjavfqi4/aok?dl=1 "Download The AOK Script").

### Step 8
At a *bash* shell, type `sudo install -Dt /usr/local/bin ~/Downloads/aok` and press enter.

### Step 9
Finally, at a *bash* shell, type `aok` and press enter.

---

## Tips
- You can press **`ctrl`**+**`d`** or **`ctrl`**+**`u`** as soon as the backlight comes on. You don't have to wait for the "OS verification is OFF" screen.
- For help using Arch Linux, visit https://wiki.archlinux.org/

## Known Issues
Issues common to latest stable linux kernel distributions on the Samsung Chromebook
- Suspend does not work properly, *don't use it*. Shut down the computer when not in use.
- \* The USB 3.0 port does not work for USB 3.0 devices, only USB 2.0 devices.
- \* The Camera does not work.
- \* The Microphone does not work.
- 3D Acceleration not yet supported (But definitely possible now due to recent (2019) updates in the Linux Kernel)

\* For USB 3.0, camera, and mic, see the peach branch of this github repo

## Notes
If you need to use a public Wi-Fi Hotspot with a Landing Page during setup, then see the WiFi Hotspot Help file in "extra".  

The default locale is English, US.

## Warnings
- Do not attempt to access files on Chrome OS when running Arch Linux [unless you know what you are doing](https://github.com/cubetronic/aok/wiki/Accessing-Files-between-Chrome-OS-and-Arch-Linux "*unless you know what you are doing*"). Improperly accessing files on Chrome OS from Arch Linux will cause Chrome OS to ERASE EVERYTHING on the Chrome OS system, including any personal files you may have stored there. In general, don't rely on storing important files on Chrome OS. See the next section.
- In rare cases, if the battery is discharged completely for a long period of time, the Chromebook may disable booting from the SD Card or USB, and ERASE EVERYTHING on the eMMC (Internal Memory), and start from a factory default state. This has nothing to do with using a custom OS such as this or enabling Developer Mode. It is a known issue with Chrome OS. For this reason, *never* store important files *solely* on the eMMC (Internal Memory) such as within Chrome OS. This does not affect the integrity of the SD Card or USB, or your files on the SD Card or USB.

## Thanks
The upstream source for this distribution comes to you from archlinuxarm.org.

https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook
