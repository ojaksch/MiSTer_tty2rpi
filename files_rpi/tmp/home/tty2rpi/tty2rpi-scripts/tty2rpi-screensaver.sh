#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

if [ "${SCREENSAVER}" = "yes" ]; then
  KILLPID feh
  if [ "${GC9A01}" = "yes" ]; then
    FRAMEBUFFER="/dev/fb1" fim --autozoom --quiet --output-device fb --random /dev/shm/ > /dev/null 2>&1 &
  else
    feh --quiet --fullscreen --randomize /dev/shm/ &
  fi
fi
