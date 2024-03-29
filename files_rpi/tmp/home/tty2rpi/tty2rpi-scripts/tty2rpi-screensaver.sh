#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

if [ "${SCREENSAVER}" = "yes" ]; then
  if [ "${FBUFDEV}" = "yes" ]; then
    KILLPID fim
    [ "${SCREENSAVER_RNDM}" = "yes" ] && RNDMZE="--random" || RNDMZE=""
    FRAMEBUFFER="${FBDEVICE}" fim --autozoom --quiet --output-device fb ${RNDMZE} --slideshow ${SCREENSAVER_IVAL} /dev/shm/ > /dev/null 2>&1 &
  else
    KILLPID feh
    [ "${SCREENSAVER_RNDM}" = "yes" ] && RNDMZE="--randomize" || RNDMZE=""
    feh --quiet --fullscreen --auto-zoom ${RNDMZE} --slideshow-delay ${SCREENSAVER_IVAL} /dev/shm/ &
  fi
fi
