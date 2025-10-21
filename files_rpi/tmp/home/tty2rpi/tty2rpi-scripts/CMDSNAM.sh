#!/bin/bash

. ~/tty2rpi.ini
. ~/tty2rpi-user.ini
. ~/tty2rpi-screens.ini
. ~/tty2rpi-functions.ini
#. <(cat ~/tty2rpi*.ini)

${IMconvert} "${TMPDIR}/pic.png" -undercolor Black -fill white -pointsize $((${WIDTH}/20)) -gravity South -draw "text 0,0 '$(<${TMPDIR}/tmp/corename)'" "${TMPDIR}/tmp/pictmp.png"
mv "${TMPDIR}/tmp/pictmp.png" "${TMPDIR}/pic.png"
