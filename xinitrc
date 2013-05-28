xset +fp /usr/share/fonts/local
xset fp rehash
xrdb ~/.Xresources
urxvtd -f
~/bin/reconfig-kbd.sh
sudo bash -c 'echo 1 > /proc/sys/kernel/sysrq'
xautolock -time 5 -locker ~/bin/lock-screen &
TERMINAL=urxvt exec i3 --force-xinerama -V
