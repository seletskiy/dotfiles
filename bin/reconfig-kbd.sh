#!/bin/bash

export XAUTHORITY=/home/s.seletskiy/.Xauthority
export DISPLAY=:0.0

xset r rate 190 70
setxkbmap -layout us,ru
xmodmap -e 'keycode 66 = ISO_Next_Group ISO_Next_Group 0x0 0x0'
