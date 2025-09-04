#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

if [ -e ~/tty2rpi-scripts/"${COMMANDLINE[0]}.sh" ]; then
  ~/tty2rpi-scripts/"${COMMANDLINE[0]}.sh" &
fi
