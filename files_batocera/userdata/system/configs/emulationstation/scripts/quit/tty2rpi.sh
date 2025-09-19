#!/bin/bash

# This is getting loaded when shutting down
exit
source /userdata/system/scripts/tty2rpi.ini
echo "CMDCOR§-§shutdown-mister" > ${TTYDEV}
