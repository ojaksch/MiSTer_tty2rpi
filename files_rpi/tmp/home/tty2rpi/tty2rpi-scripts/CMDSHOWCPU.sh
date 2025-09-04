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
${IMconvert} -size ${RESOLUTION} xc:black -pointsize $((${WIDTH}/20)) -fill white -gravity center -draw "text 0,0 '$(</tmp/cpu-info)'" /dev/shm/pictmp.png
mv /dev/shm/pictmp.png /dev/shm/pic.png
