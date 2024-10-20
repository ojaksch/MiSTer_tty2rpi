#!/bin/bash

source ~/configs/emulationstation/scripts/tty2rpi.ini

case ${1} in
  start|restart|reload)
    CORE="BATOCERA-MENU"
    ;;
  stop)
    CORE="shutdown-mister"
    ;;
esac

# tty2rpi part
echo "CMDCOR§${CORE}" > ${TTYDEV}
