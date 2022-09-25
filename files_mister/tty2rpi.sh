#!/bin/bash

# By venice & ojaksch
#
#
#

. /media/fat/tty2rpi/tty2rpi-system.ini
. /media/fat/tty2rpi/tty2rpi-user.ini
cd /tmp

# Debug function
dbug() {
  if [ "${debug}" = "true" ]; then
    echo "${1}"
    if [ ! -e ${debugfile} ]; then						# log file not (!) exists (-e) create it
      echo "---------- tty2rpi Debuglog ----------" > ${debugfile}
    fi 
    echo "${1}" >> ${debugfile}							# output debug text
  fi
}

# USB Send-Picture-Data function
senddata() {
  . /media/fat/tty2rpi/tty2rpi-user.ini						# ReRead INI for changes
  echo "CMDCOR,${1}" > ${TTYDEV}						# Instruct the device to load the appropriate picture from SD card
}

sendtime() {
  timeoffset=$(date +%:::z)
  localtime=$(date '-d now '${timeoffset}' hour' +%s)
  echo "CMDSETTIME,${localtime}" > ${TTYDEV}
}

setvideoplay() {
  dbug "Sending: CMDVIDEO,${VIDEOPLAY}"
  echo "CMDVIDEOPLAY,${VIDEOPLAY}" > ${TTYDEV}					# Set playing of videos or not
}

setscreensaver() {
  if [ "${SCREENSAVER}" = "yes" ]; then
    dbug "Sending: CMDSAVER,${SCREENSAVER_START},${SCREENSAVER_IVAL}"
    echo "CMDSAVER,${SCREENSAVER_START},${SCREENSAVER_IVAL}" > ${TTYDEV}	# Set screensaver
    sleep 0.02
    echo "CMDSAVEROPTS,${SCREENSAVER_AMPM},${SCREENSAVER_TEXT},${SCREENSAVER_PICT}" > ${TTYDEV}		# Set screensaver options
  else
    dbug "Sending: CMDSAVER,0,0"
    echo "CMDSAVER,0,0" > ${TTYDEV}						# Disable screensaver
  fi
}

# ** Main **
# Check for Command Line Parameter
if [ "${#}" -ge 1 ]; then							# Command Line Parameter given, override Parameter
  echo -e "\nUsing Command Line Parameter"
  TTYDEV=${1}									# Set TTYDEV with Parameter 1
  echo "Using Interface: ${TTYDEV}"						# Device Output
fi										# end if command line Parameter 

# Let's go
  dbug "${TTYDEV} detected, setting Parameters."
  sleep ${WAITSECS}
#  setvideoplay									# Set playing of videos or not
#  sendtime									# Set time and date
#  setscreensaver								# Set screensaver, if enabled
  while true; do								# main loop
    if [ -r ${corenamefile} ]; then						# proceed if file exists and is readable (-r)
      newcore=$(cat ${corenamefile})						# get CORENAME
      dbug "Read CORENAME: -${newcore}-"
      if [ "${newcore}" != "${oldcore}" ]; then					# proceed only if Core has changed
	dbug "Send -${newcore}- to ${TTYDEV}."
	senddata "${newcore}"							# The "Magic"
	oldcore="${newcore}"							# update oldcore variable
	#sendtime								# Update time and date
	#setscreensaver								# Reenable screensaver, if emabled
      fi									# end if core check
      if [ "${debug}" = "false" ]; then
	# wait here for next change of corename, -qq for quietness
	inotifywait -qq -e modify "${corenamefile}"
      fi
      if [ "${debug}" = "true" ]; then
	# but not -qq when debugging
	inotifywait -e modify "${corenamefile}"
      fi
    else									# CORENAME file not found
     dbug "File ${corenamefile} not found!"
    fi										# end if /tmp/CORENAME check
  done										# end while
# ** End Main **
