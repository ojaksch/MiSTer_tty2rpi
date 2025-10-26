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
  if [ "${DEBUG}" = "true" ]; then
    echo "${1}"
    if [ ! -e ${DEBUGFILE} ]; then						# log file not (!) exists (-e) create it
      echo "---------- tty2rpi Debuglog ----------" > ${DEBUGFILE}
    fi
    echo "${1}" >> ${DEBUGFILE}							# output debug text
  fi
}

# USB Send-Picture-Data function
senddata() {
  . /media/fat/tty2rpi/tty2rpi-user.ini						# ReRead INI for changes
  echo "${1}" > ${TTYDEV}							# Send command
  sleep ${WAITSECS}
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
  while true; do								# main loop
    if [ -r ${CORENAMEFILE} ]; then						# proceed if file exists and is readable (-r)
      if [ -z "${GAMESELECT}" ]; then
	newcore=$(<${CORENAMEFILE})						# get CORENAME if GAMESELECT is empty
      else
	newcore="${GAMESELECT}"
	[ "${DEBUG}" = "true" ] && logger "new core: ${GAMESELECT}"
      fi
      #
      dbug "Read CORENAME: -${newcore}-"
      if [ "${newcore}" != "${oldcore}" ]; then					# proceed only if Core has changed
	dbug "Send -${newcore}- to ${TTYDEV}."
	if [ -n "${CN}" ]; then
	  senddata "CMDCOR§${CN}§${newcore}"
	else
	  senddata "CMDCOR§-§${newcore}"						# The "Magic"
	fi
	oldcore="${newcore}"							# update oldcore variable
      fi									# end if core check
      #
      if [ $(grep -c "log_file_entry=1" /media/fat/mister.ini) = 1 ] && [ -e /tmp/CURRENTPATH ] && [ -e /tmp/FILESELECT ]; then 
	inotifywait -qq -e modify "${CORENAMEFILE}" /tmp/CURRENTPATH /tmp/FILESELECT
	CN="$(</tmp/CORENAME)"
	CP="$(</tmp/CURRENTPATH)"
	FP="$(</tmp/FULLPATH)"
	FS="$(</tmp/FILESELECT)"
	if ! [ "${FP%%/*}" = "_Arcade" ] && [ "${FS}" = "selected" ] && [ $(echo ${FP} | awk -F "/" '{print NF-1}') -ge 1 ]; then	# only when NOT on "Arcade", a game is selected and path has a depth greater than 1
	  GAMESELECT="${CN}/${CP%.*}"
	  if [ "${DEBUG}" = "true" ]; then
	    logger "============================="
	    logger "CORENAME: $CN"
	    logger "CURRENTPATH: $CP"
	    logger "FULLPATH: $FP"
	    logger "FILESELECT: $FS"
	    logger "============================="
	  fi
	else
	  [ /tmp/CORENAME -nt /tmp/CURRENTPATH ] && GAMESELECT=""
	fi
      elif [ "${DEBUG}" = "false" ]; then
	# wait here for next change of corename, -qq for quietness
	inotifywait -qq -e modify "${CORENAMEFILE}"
      elif [ "${DEBUG}" = "true" ]; then
	# but not -qq when debugging
	inotifywait -e modify "${CORENAMEFILE}"
      fi
    else									# CORENAME file not found
     dbug "File ${CORENAMEFILE} not found!"
    fi										# end if /tmp/CORENAME check
  done										# end while
# ** End Main **
