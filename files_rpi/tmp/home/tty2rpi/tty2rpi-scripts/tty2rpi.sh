#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

[ -e ~/tty2rpi-scripts/"${COMMANDLINE[0]}.sh" ] && ~/tty2rpi-scripts/"${COMMANDLINE[0]}.sh"
