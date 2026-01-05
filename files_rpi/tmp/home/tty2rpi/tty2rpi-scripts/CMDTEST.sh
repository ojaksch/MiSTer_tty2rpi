#!/bin/bash

. ~/tty2rpi.ini
. ~/tty2rpi-user.ini
. ~/tty2rpi-screens.ini
. ~/tty2rpi-functions.ini
#. <(cat ~/tty2rpi*.ini)

[ "${SCREENSAVER}" = "yes" ] && systemctl --user stop --quiet tty2rpi-screensaver.timer
if [ -f "${PATHPIC}/000-TESTBILD.png" ]; then
  cp "${PATHPIC}/000-TESTBILD.png" "${TMPDIR}/pic.png"
else
  cp "${TTY2RPIPICS}/000-notavail.png" "${TMPDIR}/pic.png"
fi
