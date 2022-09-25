#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

wget -q 'http://tasmota-0c5224-4644.com-in.de/cm?cmnd=Backlog%3BDelay%20150%3BPower%20Off' -O /dev/null # tty2rpi
sudo systemctl poweroff
