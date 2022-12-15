#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

systemctl --user stop --quiet tty2rpi-screensaver.timer
SHOWTOUT="${COMMANDLINE[1]}"
[ -z "${SHOWTOUT}" ] && SHOWTOUT=9
feh --quiet --fullscreen --randomize --auto-zoom -D ${SHOWTOUT} ${PATHPIC}
