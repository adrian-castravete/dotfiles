#!/bin/bash

export PATH=$HOME/.local/bin.local:$HOME/.local/bin:$PATH

sh $HOME/.xprofile
xrdb -I$HOME .Xresources
setxkbmap ro

sh $HOME/.screenlayout/default.sh &
sh $HOME/.fehbg &

xautolock -exit
xautolock -time 5 -locker lock -notify 5 &

killall -9 xfce4-power-manager pnmixer sxhkd dunst

xfce4-power-manager &
pnmixer &
sxhkd &
dunst &

exec dbus-launch --exit-with-session herbstluftwm
