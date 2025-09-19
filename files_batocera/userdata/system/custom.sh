#!/bin/bash

# This is getting loaded when starting or stopping Batocera

source /userdata/system/scripts/tty2rpi.ini

case ${1} in
  start|restart|reload)
    CORENAME="BATOCERA-MENU"
    ;;
  stop)
    CORENAME="shutdown-mister"
    ;;
esac

# tty2rpi part
echo "CMDCOR§-§${CORENAME}" > ${TTYDEV}
