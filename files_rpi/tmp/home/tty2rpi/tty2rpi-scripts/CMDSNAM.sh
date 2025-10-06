#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

${IMconvert} -undercolor Black -fill white -pointsize $((${WIDTH}/20)) -gravity South -draw "text 0,0 '$(<${TMPDIR}/corename)'" ${TMPDIR}/pic.png ${TMPDIR}/pictmp.png
mv ${TMPDIR}/pictmp.png ${TMPDIR}/pic.png
