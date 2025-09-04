#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

if [ "${SCREENSAVER}" = "yes" ]; then
  KILLPID feh
  [ "${SCREENSAVER_RNDM}" = "yes" ] && RNDMZE="--randomize" || RNDMZE=""
  feh --quiet --fullscreen --auto-zoom ${RNDMZE} --slideshow-delay ${SCREENSAVER_IVAL} /dev/shm/ &
fi
