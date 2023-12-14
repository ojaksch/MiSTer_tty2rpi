#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

[ "${SCREENSAVER}" = "yes" ] && systemctl --user stop --quiet tty2rpi-screensaver.timer
if [ -f "${PATHPIC}/000-TESTBILD.png" ]; then
  PICSIZE=$(identify -format '%wx%h' "${PATHPIC}/${MEDIA}")
  if [ "${PICSIZE}" != "${WIDTH}x${HEIGHT}" ]; then
    ffmpeg -y -loglevel quiet -i "${PATHPIC}/000-TESTBILD.png" -vf scale=${WIDTH}:${HEIGHT} /tmp/testpic.png
  else
    if [ "${GC9A01}" = "yes" ]; then
      FRAMEBUFFER="/dev/fb1" fim --autozoom --quiet --output-device fb "${PATHPIC}/000-TESTBILD.png" > /dev/null 2>&1
    else
      feh --quiet --fullscreen "${PATHPIC}/000-TESTBILD.png"
    fi
  fi
else
  cp ~/tty2rpi-pics/000-notavail.png /dev/shm/pic.png
fi
if [ "${GC9A01}" = "yes" ]; then
  FRAMEBUFFER="/dev/fb1" fim --autozoom --quiet --output-device fb /tmp/testpic.png > /dev/null 2>&1
else
  feh --quiet --fullscreen /tmp/testpic.png
fi
