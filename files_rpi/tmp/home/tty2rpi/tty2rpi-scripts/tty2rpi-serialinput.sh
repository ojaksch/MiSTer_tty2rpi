#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

stty --file /dev/ttyAMA0 115200 cs8 raw -parenb -cstopb -hupcl -echo
read COMMAND < /dev/ttyAMA0 && echo "${COMMAND}" > ${SOCKET}
