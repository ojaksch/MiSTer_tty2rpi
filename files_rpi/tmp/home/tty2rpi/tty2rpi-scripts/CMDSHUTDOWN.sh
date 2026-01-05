#!/bin/bash

. ~/tty2rpi.ini
. ~/tty2rpi-user.ini
. ~/tty2rpi-screens.ini
. ~/tty2rpi-functions.ini
#. <(cat ~/tty2rpi*.ini)

# wget -q 'http://tasmota-012345-1234.example.,org/cm?cmnd=Backlog%3BDelay%20150%3BPower%20Off' -O /dev/null # tty2rpi
sudo systemctl poweroff
