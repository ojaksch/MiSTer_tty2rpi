#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

[ -e ~/tty2rpi-scripts/"${COMMANDLINE[0]}.sh" ] && ~/tty2rpi-scripts/"${COMMANDLINE[0]}.sh"
