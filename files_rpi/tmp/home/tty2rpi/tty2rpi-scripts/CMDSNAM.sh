#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

${IMconvert} -undercolor Black -fill white -pointsize $((${WIDTH}/20)) -gravity South -draw "text 0,0 '$(</dev/shm/corename)'" /dev/shm/pic.png /dev/shm/pictmp.png
mv /dev/shm/pictmp.png /dev/shm/pic.png
