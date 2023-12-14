#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

convert -size ${RESOLUTION} xc:black -pointsize $((${WIDTH}/20)) -fill white -gravity center -draw "text 0,0 'Waiting for network...'" /tmp/wait4inet.png
if [ "${GC9A01}" = "yes" ]; then
  FRAMEBUFFER="/dev/fb1" fim --autozoom --quiet --output-device fb /tmp/wait4inet.png > /dev/null 2>&1 &
else
  feh --quiet --fullscreen /tmp/wait4inet.png &
fi
until ping -c1 www.google.de >/dev/null 2>&1; do sleep 1; done
if [ "${GC9A01}" = "yes" ]; then
  KILLPID fim
else
  KILLPID feh
fi

echo -e "Your IP adress(es) for\nhostname $(hostname -f):\n" > /tmp/ip-adresses
ip -o addr | awk '!/^[0-9]*: ?lo|link\/ether/ {gsub("/", " "); print $2" "$4}' >> /tmp/ip-adresses
convert -size ${RESOLUTION} xc:black -pointsize $((${WIDTH}/25)) -fill white -gravity center -draw "text 0,0 '$(cat /tmp/ip-adresses)'" /tmp/ip-adresses.png
if [ "${GC9A01}" = "yes" ]; then
  FRAMEBUFFER="/dev/fb1" fim --autozoom --quiet --output-device fb /tmp/ip-adresses.png > /dev/null 2>&1
else
  feh --quiet --fullscreen /tmp/ip-adresses.png
fi
