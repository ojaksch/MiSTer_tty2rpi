#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

systemctl --user stop --quiet tty2rpi-screensaver.timer
if [ -f "${PATHPIC}/000-TESTBILD.png" ]; then
  PICSIZE=$(identify -format '%wx%h' "${PATHPIC}/${MEDIA}")
  if [ "${PICSIZE}" != "${WIDTH}x${HEIGHT}" ]; then
    ffmpeg -y -loglevel quiet -i "${PATHPIC}/000-TESTBILD.png" -vf scale=${WIDTH}:${HEIGHT} /tmp/testpic.png
  else
    feh --quiet --fullscreen "${PATHPIC}/000-TESTBILD.png"
  fi
else
  cp ~/tty2rpi-pics/000-notavail.png /dev/shm/pic.png
fi
feh --quiet --fullscreen /tmp/testpic.png
