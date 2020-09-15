#!/bin/bash

export PATH=$HOME/.local/bin.local:$HOME/.local/bin:$PATH

sh $HOME/.xprofile
xrdb -I$HOME .Xresources
setxkbmap ro

# IceWM {{{
#xautolock -exit
#xautolock -time 5 -locker lock -notify 5 &

#exec dbus-launch --exit-with-session icewm-session >> $HOME/.icewm.out 2>> $HOME/.icewm.err
# }}}

# TinyWM {{{
#xautolock -exit
#xautolock -time 5 -locker lock -notify 5 &
#stalonetray &
#exec tinywm.py > $HOME/.tinywm.out 2> $HOME/.tinywm.err
# }}}

# Sawfish WM {{{
exec dbus-launch --exit-with-session sawfish-xfce-session > $HOME/.sawfish.out 2> $HOME/.sawfish.err
# }}}
