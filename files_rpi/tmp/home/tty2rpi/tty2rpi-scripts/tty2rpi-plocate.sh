#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

updatedb -l 0 -U ${HOME} -o /dev/shm/tmp/mediadb
