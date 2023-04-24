#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

if [ "${SCREENSAVER}" = "yes" ]; then
  KILLPID feh
  feh --quiet --fullscreen --randomize /dev/shm/ &
fi
