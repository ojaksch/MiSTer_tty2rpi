#!/bin/bash

. ~/tty2rpi.ini
. ~/tty2rpi-user.ini
. ~/tty2rpi-screens.ini
. ~/tty2rpi-functions.ini
#. <(cat ~/tty2rpi*.ini)

if [ "${UPDATESONSHUTDOWN}" = "yes" ]; then
  systemctl --user stop --quiet tty2rpi-screensaver.timer

  touch /tmp/xconsole
  cp ~/.xconsole.rsc /tmp/xconsole.rsc
  sed -i 's/#WIDTH#/'${WIDTH}'/' /tmp/xconsole.rsc
  sed -i 's/#HEIGHT#/'$((HEIGHT/3*2))'/' /tmp/xconsole.rsc

  KILLPID feh
  magick -size ${RESOLUTION} xc:black -pointsize $((${WIDTH}/20)) -fill white -gravity center -draw "text 0,"$((HEIGHT/3))" 'Updating OS packages...'" "/tmp/update.png"
  feh --quiet --fullscreen /tmp/update.png &

  export XENVIRONMENT=/tmp/xconsole.rsc
  xconsole -file /tmp/xconsole -daemon
  while [ -z $(pidof xconsole) ] ; do sleep 0.2; done
  sleep 1
  xprop -name xconsole -set WM_NAME "The udater routine"

  sudo apt-get -y update >> /tmp/xconsole
  sudo apt-get -y dist-upgrade >> /tmp/xconsole

  if [ "${UPDATESCLEANUP}" = "yes" ]; then
    echo -e "---------------------------\nCleaning up..." >> /tmp/xconsole
    sudo apt-get -y autoremove > /dev/null 2>&1
    sudo apt-get -y autoclean > /dev/null 2>&1
  fi
  KILLPID xconsole
fi

cp "${TTY2RPIPICS}/tty2rpi-shutdown.png" /tmp/update.png
sync
sudo systemctl poweroff
