#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

echo "Raspberrys CPU:" > /tmp/cpu-info
TEMPC=`awk '{printf "%3.1f°C\n", $1/1000}' /sys/class/thermal/thermal_zone0/temp`
TEMPF=`awk '{printf "%3.1f°F\n", $1/1000*1.8+32}' /sys/class/thermal/thermal_zone0/temp`
let SPEED=`</sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`/1000
echo "CPU-Speed: ${SPEED} MHz" >> /tmp/cpu-info
echo "CPU-Temperature: ${TEMPC} / ${TEMPF}" >> /tmp/cpu-info
convert -size ${RESOLUTION} xc:black -pointsize $((${WIDTH}/20)) -fill white -gravity center -draw "text 0,0 '$(</tmp/cpu-info)'" /tmp/cpu-info.png
if [ "${FBUFDEV}" = "yes" ]; then
  FRAMEBUFFER="${FBDEVICE}" fim --autozoom --quiet --output-device fb /tmp/cpu-info.png > /dev/null 2>&1 &
else
  feh --quiet --fullscreen --auto-zoom /tmp/cpu-info.png &
fi
