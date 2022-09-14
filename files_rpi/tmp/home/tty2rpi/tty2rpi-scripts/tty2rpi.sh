#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

MEDIA=$(tail -n1 ${SOCKET} | tr -d '\0')	# Get corename from socket, ripped off "null byte" trash
MEDIAPIC="${MEDIA}"
MEDIAVID="${MEDIA}"

logger "Socket got »${MEDIA}«"
if [ "${MEDIA}" = "tty2rpi-screensaver" ]; then
  feh -q -F -z /dev/shm/*
else
  systemctl --user stop --quiet tty2rpi-screensaver.timer

  GETFNAM "${PATHPIC}" "${MEDIAPIC}"
  if ([ "${MEDIA%.*}" = "MENU" ] || [ "${MEDIA%.*}" = "MAME-MENU" ] || [ "${MEDIA%.*}" = "MISTER-MENU" ]); then cp "${PATHPIC}/${MEDIA}" /dev/shm; fi
  #[ -f "${PATHPIC}/${MEDIA}" ] && ffmpeg -y -loglevel quiet -i "${PATHPIC}/${MEDIA}" -vf scale=${WIDTH}:${HEIGHT} /dev/shm/pic.png & echo $! > /dev/shm/convert.pid
  if [ -f "${PATHPIC}/${MEDIA}" ]; then
    PICSIZE=$(identify -format '%wx%h' "${PATHPIC}/${MEDIA}")
    if [ "${PICSIZE}" != "${WIDTH}x${HEIGHT}" ]; then
      convert "${PATHPIC}/${MEDIA}" -resize ${WIDTH}x${HEIGHT}\! /dev/shm/pic.png & echo $! > /dev/shm/convert.pid
    else
      cp "${PATHPIC}/${MEDIA}" /dev/shm/pic.png
    fi
  else
    cp ~/tty2rpi-pics/000-notavail.png /dev/shm/pic.png
  fi

  GETFNAM "${PATHVID}" "${MEDIAVID}"
  if ([ "${MEDIA%.*}" = "MENU" ] || [ "${MEDIA%.*}" = "MAME-MENU" ] || [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${SOUNDMENU}" = "no" ]; then VLCAUDIO="--no-audio"; fi
  if (! [ "${MEDIA%.*}" = "MENU" ] && ! [ "${MEDIA%.*}" = "MAME-MENU" ] && ! [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${SOUNDARCADE}" = "no" ]; then VLCAUDIO="--no-audio"; fi
  if (! [ "${MEDIA%.*}" = "MENU" ] && ! [ "${MEDIA%.*}" = "MAME-MENU" ] && ! [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${VIDEOARCADE=}" = "no" ]; then PLAYVIDEO="no"; fi
  if [ "${PLAYVIDEO}" = "yes" ]; then
    [ -f "${PATHVID}/${MEDIA}" ] && cvlc -f --no-video-title-show --play-and-exit --verbose 0 --aout alsa ${VLCAUDIO} ${VLCPREFEETCH} "${PATHVID}/${MEDIA}"
  fi

  # Wait for the completion of the convert process
  if [ -e /dev/shm/convert.pid ]; then
    while [ -d /proc/$(</dev/shm/convert.pid) ] ; do sleep 0.1; done
    rm /dev/shm/convert.pid
  fi
  systemctl --user start --quiet tty2rpi-screensaver.timer
  feh -q -F /dev/shm/pic.png
fi
