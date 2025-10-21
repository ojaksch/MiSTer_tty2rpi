#!/bin/bash

. ~/tty2rpi.ini
. ~/tty2rpi-user.ini
. ~/tty2rpi-screens.ini
. ~/tty2rpi-functions.ini
#. <(cat ~/tty2rpi*.ini)

if [ -e ~/tty2rpi-scripts/"${COMMANDLINE[0]}.sh" ]; then
  ~/tty2rpi-scripts/"${COMMANDLINE[0]}.sh" &
fi
