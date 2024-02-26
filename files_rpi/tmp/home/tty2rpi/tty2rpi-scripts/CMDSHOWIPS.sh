#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

convert -size ${RESOLUTION} xc:black -pointsize $((${WIDTH}/20)) -fill white -gravity center -draw "text 0,0 'Waiting for network...'" /tmp/wait4inet.png
if [ "${FBUFDEV}" = "yes" ]; then
  FRAMEBUFFER="${FBDEVICE}" fim --autozoom --quiet --output-device fb /tmp/wait4inet.png > /dev/null 2>&1 &
else
  feh --quiet --fullscreen --auto-zoom /tmp/wait4inet.png &
fi

DEFGW="$(ip route | grep "default via" | awk '{print $3}')"
until ping -c1 "${DEFGW}" >/dev/null 2>&1; do sleep 1; done
if [ "${FBUFDEV}" = "yes" ]; then
  KILLPID fim
else
  KILLPID feh
fi

echo -e "Your IP adress(es) for\nhostname $(hostname -f):\n" > /tmp/ip-adresses
ip -o addr | awk '!/^[0-9]*: ?lo|link\/ether/ {gsub("/", " "); print $2" "$4}' >> /tmp/ip-adresses
convert -size ${RESOLUTION} xc:black -pointsize $((${WIDTH}/25)) -fill white -gravity center -draw "text 0,0 '$(</tmp/ip-adresses)'" /tmp/ip-adresses.png
if [ "${FBUFDEV}" = "yes" ]; then
  FRAMEBUFFER="${FBDEVICE}" fim --autozoom --quiet --output-device fb /tmp/ip-adresses.png > /dev/null 2>&1
else
  feh --quiet --fullscreen --auto-zoom /tmp/ip-adresses.png
fi
