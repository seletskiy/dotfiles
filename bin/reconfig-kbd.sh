#!/bin/bash

export XAUTHORITY=/home/s.seletskiy/.Xauthority
export DISPLAY=:0.0

xset r rate 200 60
setxkbmap \
    -keycodes \
        "evdev+aliases(qwerty)+disable-arrows" \
    -symbols \
        "pc+us+ru:2+hjkl-ru+level3(lwin_switch)+mod4-lvl3+terminate(ctrl_alt_bksp)+capslock-groupshift+altwin(swap_alt_win)" \
    -compat \
        "complete+hjkl"
