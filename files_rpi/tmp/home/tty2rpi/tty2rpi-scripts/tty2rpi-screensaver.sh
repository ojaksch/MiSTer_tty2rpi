#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

if [ "${SCREENSAVER}" = "yes" ]; then
  if [ "${FBUFDEV}" = "yes" ]; then
    KILLPID fim
    FRAMEBUFFER="${FBDEVICE}" fim --autozoom --quiet --output-device fb --random /dev/shm/ > /dev/null 2>&1 &
  else
    KILLPID feh
    feh --quiet --fullscreen --randomize /dev/shm/ &
  fi
fi
