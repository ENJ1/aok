#!/bin/bash -ev

## DEPENDS: files/arch_linux_gnome_menu_icon_by_byamato.png
## DEPENDS: files/bright_background_light_texture_50370_1366x768.jpg

# INSTALL TEXTURED GREY WALLPAPER
install -o root -g root -m 0644 -D \
files/bright_background_light_texture_50370_1366x768.jpg \
/usr/share/backgrounds/xfce/bright_background_light_texture_50370_1366x768.jpg

## ARCH LINUX ICON
install -o root -g root -m 0644 -D \
files/arch_linux_gnome_menu_icon_by_byamato.png \
/usr/share/icons/arch_linux_gnome_menu_icon_by_byamato.png

## LIGHTDM LOGIN BACKGROUND
install -o root -g root -m 0644 -D \
files/linux_archlinux_os_blue_black_logo_30861_1366x768.jpg \
/usr/share/pixmaps/linux_archlinux_os_blue_black_logo_30861_1366x768.jpg

## LIGHTDM BACKGROUND SETTINGS
install -o root -g root -m 0644 -D \
files/home/a/Desktop/aok-nov-7b/files/lightdm-gtk-greeter.conf \
/etc/lightdm/lightdm-gtk-greeter.conf

