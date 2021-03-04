#!/bin/bash

export PATH=$HOME/.local/bin.local:$HOME/.local/bin:$PATH

sh $HOME/.xprofile
xrdb -I$HOME .Xresources
setxkbmap ro
xset b off

#exec dbus-launch --exit-with-session icewm-session > $HOME/.icewm.out 2> $HOME/.icewm.err
#exec dbus-launch --exit-with-session fvwm > $HOME/.fvwm.out 2> $HOME/.fvwm.err

sh $HOME/.screenlayout/default.sh &
sh $HOME/.fehbg &
xautolock -exit
xautolock -time 5 -locker lock -notify 5 -bell 5 &
dwmstatus.lua &
xfce4-power-manager &
pnmixer &
exec dbus-launch --exit-with-session dwm > $HOME/.dwm.out 2> $HOME/.dwm.err
