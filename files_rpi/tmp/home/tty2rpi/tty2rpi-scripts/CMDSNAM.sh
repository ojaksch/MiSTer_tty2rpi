#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

${IMconvert} -undercolor Black -fill white -pointsize $((${WIDTH}/20)) -gravity South -draw "text 0,0 '$(</dev/shm/corename)'" /dev/shm/pic.png /dev/shm/pic.png

if [ "${FBUFDEV}" = "yes" ]; then
  FRAMEBUFFER="${FBDEVICE}" fim --autozoom --quiet --output-device fb /dev/shm/pic.png > /dev/null 2>&1
else
  feh --quiet --fullscreen --auto-zoom /dev/shm/pic.png
fi
