#!/bin/bash -ev

## DEPENDS ON ARCH LINUX PACKAGE: xorg-xinput

## SLOW DOWN A LOGITECH MOUSE
MOUSE=$(xinput | grep -i 'Mouse' | grep 'pointer' | cut -c55-56)
PROP=$(xinput list-props $MOUSE | grep 'Accel Speed (' | cut -c24-26)
xinput set-prop $MOUSE $PROP -1 || {
  # IF THAT FAILED, THERE'S NO MOUSE, SO ENABLE THE TRACKPAD
  TRACKPAD=$(xinput | grep -i 'Trackpad' | cut -c55-56)
  xinput enable $TRACKPAD
  exit 0
}

## IF THE LAST COMMAND SUCCEEDED, THEN THERE IS A MOUSE
## SO DISABLE THE TRACKPAD
TRACKPAD=$(xinput | grep -i 'Trackpad' | cut -c55-56)
xinput disable $TRACKPAD

