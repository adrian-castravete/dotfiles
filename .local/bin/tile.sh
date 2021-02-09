#!/bin/bash

# recover max native resolution
CURRES=$(xrandr | grep -m 1 '   .*' | awk  '{print $1}')
FULLW="$(cut -d'x' -f1 <<< $CURRES)"
FULLH="$(cut -d'x' -f2 <<< $CURRES)"

# taskbar pixel height
DIFFW=8
DIFFH=60 # hardcoded

# active window id
# ID="-r :ACTIVE:" # does not work as consistently as the call to xdotool
ID="-i -r `xdotool getwindowfocus`"

# disable maximized attribute
wmctrl $ID -b remove,maximized_vert
wmctrl $ID -b remove,maximized_horz

case "$1" in
    w)
        # tile left
        W=$((($FULLW - $DIFFW * 2) / 2))
        H=$(($FULLH - $DIFFH))
        X=0
        Y=0
        ;;
    e)
        # tile right
        W=$((($FULLW - $DIFFW * 2) / 2))
        H=$(($FULLH - $DIFFH))
        X=$(($W + $DIFFW))
        Y=0
        ;;
esac

echo "$X $Y $W $H"

# resize
wmctrl $ID -e 0,$X,$Y,$W,$H
