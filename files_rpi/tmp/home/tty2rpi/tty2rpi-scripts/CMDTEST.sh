#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

[ "${SCREENSAVER}" = "yes" ] && systemctl --user stop --quiet tty2rpi-screensaver.timer
if [ -f "${PATHPIC}/000-TESTBILD.png" ]; then
  cp "${PATHPIC}/000-TESTBILD.png" "${TMPDIR}/pic.png"
else
  cp "${TTY2RPIPICS}/000-notavail.png" "${TMPDIR}/pic.png"
fi
