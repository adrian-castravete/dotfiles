#!/bin/bash

export PATH=$HOME/.local/bin.local:$HOME/.local/bin:$PATH

sh $HOME/.xprofile
xrdb -I$HOME .Xresources
setxkbmap ro

xautolock -exit
xautolock -time 5 -locker lock -notify 5 &

#exec dbus-launch --exit-with-session icewm-session >> $HOME/.icewm.out 2>> $HOME/.icewm.err

#stalonetray &
#exec tinywm.py > $HOME/.tinywm.out 2> $HOME/.tinywm.err

exec dbus-launch --exit-with-session sawfish-xfce-session > $HOME/.sawfish.out 2> $HOME/.sawfish.err
