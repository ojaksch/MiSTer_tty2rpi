#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

convert -undercolor Black -fill white -pointsize $((${WIDTH}/20)) -gravity South -draw "text 0,0 '$(cat /dev/shm/corename)'" /dev/shm/pic.png /dev/shm/pic.png

if [ "${GC9A01}" = "yes" ]; then
  FRAMEBUFFER="/dev/fb1" fim --autozoom --quiet --output-device fb /dev/shm/pic.png > /dev/null 2>&1
else
  feh --quiet --fullscreen /dev/shm/pic.png
fi
