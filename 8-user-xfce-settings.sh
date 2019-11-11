#!/bin/bash -ev

## CHANGE DESKTOP BACKGROUND FOR "workspace0"
xfconf-query \
-c xfce4-desktop \
-p /backdrop/screen0/monitor0/workspace0/last-image \
-s "/usr/share/backgrounds/xfce/bright_background_light_texture_50370_1366x768.jpg"

## CHANGE DESKTOP BACKGROUND FOR OTHER 3 WORKSPACES
## IN CASE THE USER SETS /backdrop/single-workspace-mode TO "false"
xfconf-query \
-c xfce4-desktop \
-p /backdrop/screen0/monitor0/workspace1/last-image \
-s "/usr/share/backgrounds/xfce/bright_background_light_texture_50370_1366x768.jpg"
xfconf-query \
-c xfce4-desktop \
-p /backdrop/screen0/monitor0/workspace2/last-image \
-s "/usr/share/backgrounds/xfce/bright_background_light_texture_50370_1366x768.jpg"
xfconf-query \
-c xfce4-desktop \
-p /backdrop/screen0/monitor0/workspace3/last-image \
-s "/usr/share/backgrounds/xfce/bright_background_light_texture_50370_1366x768.jpg"

## MOVE THE TASKBAR TO THE BOTTOM OF THE SCREEN
xfconf-query \
-c xfce4-panel \
-p /panels/panel-1/position \
-s "p=8;x=683;y=754"

## PREVENT LOADING OF PANEL 2, BY SETTING PANEL ARRAY TO JUST 1
## THEREBY MAKING PANEL 2 SORT OF NON-EXISTANT
## BUT IT STILL HAS ALL ITS PROPERTIES, AND CAN BE BROUGHT BACK.
xfconf-query -c xfce4-panel -p /panels -t int -s 1 -a

## CHANGE MENU BUTTON (START BUTTON) ICON
xfconf-query \
-c xfce4-panel \
-p /plugins/plugin-1/button-icon \
-n -t string \
-s "arch_linux_gnome_menu_icon_by_byamato"

## CHANGE MENU BUTTON TEXT TO "Menu"
xfconf-query \
-c xfce4-panel \
-p /plugins/plugin-1/button-title \
-n -t string \
-s "Menu"

## DON'T SHOW THAT TEXT NEXT TO MENU BUTTON (START BUTTON) ANYWAY
xfconf-query \
-c xfce4-panel \
-p /plugins/plugin-1/show-button-title \
-n -t bool \
-s false

## RELOAD PANEL(S)
xfce4-panel -r
