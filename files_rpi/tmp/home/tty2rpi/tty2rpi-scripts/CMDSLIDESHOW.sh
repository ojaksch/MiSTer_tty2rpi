#!/bin/bash

. ~/tty2rpi.ini
. ~/tty2rpi-user.ini
. ~/tty2rpi-screens.ini
. ~/tty2rpi-functions.ini
#. <(cat ~/tty2rpi*.ini)

[ "${SCREENSAVER}" = "yes" ] && systemctl --user stop --quiet tty2rpi-screensaver.timer
SHOWTOUT="${COMMANDLINE[1]}"
[ -z "${SHOWTOUT}" ] && SHOWTOUT=9
feh --quiet --fullscreen --auto-zoom --randomize --auto-zoom --slideshow-delay "${SHOWTOUT}" "${PATHPIC}"
