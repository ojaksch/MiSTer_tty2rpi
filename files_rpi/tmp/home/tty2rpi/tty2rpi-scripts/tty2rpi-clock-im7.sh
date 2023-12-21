#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

[ "${SCREENSAVER_AMPM}" = "yes" ] && DATEFULL=$(date +%I%M)
[ "${SCREENSAVER_AMPM}" = "no" ] && DATEFULL=$(date +%H%M)
DATEH1=${DATEFULL:0:1}
DATEH2=${DATEFULL:1:1}
DATEM1=${DATEFULL:2:1}
DATEM2=${DATEFULL:3:1}

CLOCKPATH="${HOME}/tty2rpi-pics"
CLOCKPNG="/dev/shm/tty2rpi-clock.png"

magick -size 500x320 xc:black ${CLOCKPNG}
magick composite ${CLOCKPATH}/000-clock.png ${CLOCKPNG} ${CLOCKPNG}

magick composite -geometry  +45+155 ${CLOCKPATH}/000-clock-${DATEH1}.jpg ${CLOCKPNG} ${CLOCKPNG}
magick composite -geometry  +140+155 ${CLOCKPATH}/000-clock-${DATEH2}.jpg ${CLOCKPNG} ${CLOCKPNG}
magick composite -geometry  +265+155 ${CLOCKPATH}/000-clock-${DATEM1}.jpg ${CLOCKPNG} ${CLOCKPNG}
magick composite -geometry  +360+155 ${CLOCKPATH}/000-clock-${DATEM2}.jpg ${CLOCKPNG} ${CLOCKPNG}

echo "tty2rpi-screensaver" > "${SOCKET}"
