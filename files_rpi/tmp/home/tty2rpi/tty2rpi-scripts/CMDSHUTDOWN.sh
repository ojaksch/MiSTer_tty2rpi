#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

# wget -q 'http://tasmota-012345-1234.example.,org/cm?cmnd=Backlog%3BDelay%20150%3BPower%20Off' -O /dev/null # tty2rpi
sudo systemctl poweroff
