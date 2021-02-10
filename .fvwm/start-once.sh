#!/bin/sh

compton -I 0.1 -O 0.05 -e 0.9 -c -z -f --blur-background --blur-kern '7,7,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1' --resize-damage=2 --backend glx &
#compton -I 0.1 -O 0.05 -e 0.9 -c -z -f --blur-background --blur-kern '5,5,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0' --resize-damage=2 --backend glx &
#compton -I 0.1 -O 0.05 -e 0.9 -c -z -f --blur-background --blur-kern '3,3,0,0,1,0,0,1,0,0' --resize-damage=1 --backend glx &
#compton -I 0.1 -O 0.05 -e 0.9 -c -z -f &
pnmixer &
redshift-gtk &
xfsettingsd --replace &
#xfdesktop &
xfce4-power-manager &
