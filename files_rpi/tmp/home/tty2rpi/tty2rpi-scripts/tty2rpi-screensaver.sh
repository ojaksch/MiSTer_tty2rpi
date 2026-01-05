#!/bin/bash

. ~/tty2rpi.ini
. ~/tty2rpi-user.ini
. ~/tty2rpi-screens.ini
. ~/tty2rpi-functions.ini
#. <(cat ~/tty2rpi*.ini)

if ! [ -e "${TMPDIR}/tmp/screesaver.pid" ]; then
  if [ "${SCREENSAVER}" = "yes" ]; then
    KILLPID feh
    [ "${SCREENSAVER_RNDM}" = "yes" ] && RNDMZE="--randomize" || RNDMZE=""
    feh --quiet --fullscreen --auto-zoom "${RNDMZE}" --slideshow-delay "${SCREENSAVER_IVAL}" "${TMPDIR}"/ & echo $! > "${TMPDIR}/tmp/screesaver.pid"
  fi
fi
