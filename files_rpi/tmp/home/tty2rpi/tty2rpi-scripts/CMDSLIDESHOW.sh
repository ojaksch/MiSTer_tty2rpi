#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

[ "${SCREENSAVER}" = "yes" ] && systemctl --user stop --quiet tty2rpi-screensaver.timer
SHOWTOUT="${COMMANDLINE[1]}"
[ -z "${SHOWTOUT}" ] && SHOWTOUT=9
if [ "${FBUFDEV}" = "yes" ]; then
  FRAMEBUFFER="${FBDEVICE}" fim --autozoom --quiet --output-device fb --slideshow ${SHOWTOUT} ${PATHPIC} > /dev/null 2>&1
else
  feh --quiet --fullscreen --randomize --auto-zoom --slideshow-delay ${SHOWTOUT} ${PATHPIC}
fi
