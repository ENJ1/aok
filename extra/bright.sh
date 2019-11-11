#!/bin/bash

## CHANGE BRIGHTNESS WHILE STILL AT THE COMMAND LINE
nano /sys/devices/platform/backlight/backlight/backlight/brightness

## NOTES
## (7 is really bright, 5 is less bright, 1 is very dim)
## (i would not try 0, this may render your installation useless, however,
## brightness setting does not affect boot screen, so it won't really brick
## your device to do this, just make it so that retrieving files might be
## impossible)

