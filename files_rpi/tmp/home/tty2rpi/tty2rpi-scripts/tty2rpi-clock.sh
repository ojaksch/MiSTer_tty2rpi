#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

if [ ${SCREENSAVER_CLOCK} = "no" ] && [ -f /dev/shm/tty2rpi-clock.png ]; then
  rm /dev/shm/tty2rpi-clock.png
fi

if [ "${SCREENSAVER}" = "yes" ] && [ ${SCREENSAVER_CLOCK} = "yes" ]; then
  [ "${SCREENSAVER_AMPM}" = "yes" ] && DATEFULL=$(date +%I%M)
  [ "${SCREENSAVER_AMPM}" = "no" ] && DATEFULL=$(date +%H%M)
  DATEH1=${DATEFULL:0:1}
  DATEH2=${DATEFULL:1:1}
  DATEM1=${DATEFULL:2:1}
  DATEM2=${DATEFULL:3:1}

  CLOCKPNG="/dev/shm/tty2rpi-clock.png"
  CLOCKPNGTMP="/dev/shm/tmp/tty2rpi-clock.png"

  convert -size 500x320 xc:black ${CLOCKPNGTMP}
  composite ${TTY2RPIPICS}/000-clock.png ${CLOCKPNGTMP} ${CLOCKPNGTMP}

  composite -geometry  +45+155 ${TTY2RPIPICS}/000-clock-${DATEH1}.jpg ${CLOCKPNGTMP} ${CLOCKPNGTMP}
  composite -geometry  +140+155 ${TTY2RPIPICS}/000-clock-${DATEH2}.jpg ${CLOCKPNGTMP} ${CLOCKPNGTMP}
  composite -geometry  +265+155 ${TTY2RPIPICS}/000-clock-${DATEM1}.jpg ${CLOCKPNGTMP} ${CLOCKPNGTMP}
  composite -geometry  +360+155 ${TTY2RPIPICS}/000-clock-${DATEM2}.jpg ${CLOCKPNGTMP} ${CLOCKPNGTMP}

  mv ${CLOCKPNGTMP} ${CLOCKPNG}
fi

[ "${COMMANDLINE}" != "tty2rpi-screensaver" ] && echo "tty2rpi-screensaver" > "${SOCKET}"
exit 0
