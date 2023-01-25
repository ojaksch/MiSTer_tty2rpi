#!/bin/bash

source /userdata/system/scripts/tty2rpi.ini
echo "CMDCOR,shutdown-mister" > ${TTYDEV}
