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
pnmixer &
redshift-gtk &
xfsettingsd --replace &
xfce4-power-manager &

compton -I 0.1 -O 0.05 -e 0.9 -c -z -f --blur-background --blur-kern '7,7,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1' --resize-damage=2 --backend glx &

exec dbus-launch --exit-with-session dwm > $HOME/.dwm.out 2> $HOME/.dwm.err
