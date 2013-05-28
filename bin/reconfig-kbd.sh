#!/bin/bash

export XAUTHORITY=/home/s.seletskiy/.Xauthority
export DISPLAY=:0.0

xmodmap -e 'keycode 66 = ISO_Next_Group ISO_Next_Group'
nohup bash -c 'sleep 1 ; xset r rate 190 50' &
