#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

echo -e "Your IP adress(es) for\nhostname $(hostname -f):\n" > /tmp/ip-adresses
ip -o addr | awk '!/^[0-9]*: ?lo|link\/ether/ {gsub("/", " "); print $2" "$4}' >> /tmp/ip-adresses
convert -size ${RESOLUTION} xc:black -pointsize $((${WIDTH}/20)) -fill white -gravity center -draw "text 0,0 '$(cat /tmp/ip-adresses)'" /tmp/ip-adresses.png
feh -q -F /tmp/ip-adresses.png &
