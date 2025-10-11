#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

${IMconvert} -size ${RESOLUTION} xc:black -pointsize $((${WIDTH}/20)) -fill white -gravity center -draw "text 0,0 'Waiting for network...'" "${TMPDIR}/pictmp.png"
mv "${TMPDIR}/pictmp.png" "${TMPDIR}/pic.png"
until [ $(ip link | grep -c "state UP") -gt 0 ]; do true; sleep 0.2; done

DEFGW="$(ip route | head -n1 | grep "default via" | awk '{print $3}')"
until ping -c1 "${DEFGW}" >/dev/null 2>&1; do sleep 1; done

echo -e "Your IP address(es) for\nhostname $(hostname -f):\n" > /tmp/ip-addresses
ip -o addr | awk '!/^[0-9]*: ?lo|link\/ether/ {gsub("/", " "); print $2" "$4}' >> /tmp/ip-addresses
sed -i '/ fd23:/d' /tmp/ip-addresses
sed -i '/ fe80:/d' /tmp/ip-addresses
${IMconvert} -size ${RESOLUTION} xc:black -pointsize $((${WIDTH}/25)) -fill white -gravity center -draw "text 0,0 '$(</tmp/ip-addresses)'" "${TMPDIR}/pictmp.png"
mv "${TMPDIR}/pictmp.png" "${TMPDIR}/pic.png"
