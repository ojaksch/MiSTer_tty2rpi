#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

MEDIAPIC="${COMMANDLINE[1]}"
MEDIAVID="${COMMANDLINE[1]}"

MEDIA="${COMMANDLINE[1]}"
logger "Socket got »${MEDIA}«"
echo "${MEDIA}" > /dev/shm/corename
systemctl --user stop --quiet tty2rpi-screensaver.timer

GETFNAM "${PATHPIC}" "${MEDIAPIC}"
if ([ "${MEDIA%.*}" = "MENU" ] || [ "${MEDIA%.*}" = "MAME-MENU" ] || [ "${MEDIA%.*}" = "MISTER-MENU" ]); then cp "${PATHPIC}/${MEDIA}" /dev/shm; fi
#[ -f "${PATHPIC}/${MEDIA}" ] && ffmpeg -y -loglevel quiet -i "${PATHPIC}/${MEDIA}" -vf scale=${WIDTH}:${HEIGHT} /dev/shm/pic.png & echo $! > /dev/shm/convert.pid
if [ -f "${PATHPIC}/${MEDIA}" ]; then
  PICSIZE=$(identify -format '%wx%h' "${PATHPIC}/${MEDIA}")
  if [ "${PICSIZE}" != "${WIDTH}x${HEIGHT}" ]; then
    #convert "${PATHPIC}/${MEDIA}" -resize ${WIDTH}x${HEIGHT}\! /dev/shm/pic.png & echo $! > /dev/shm/convert.pid
    #TTT=$(time convert "${PATHPIC}/${MEDIA}" -resize ${WIDTH}x${HEIGHT}\! /dev/shm/pic.png)
    [ "${KEEPASPECTRATIO}" = "yes" ] && WIDTH=0
    ffmpeg -y -loglevel quiet -i "${PATHPIC}/${MEDIA}" -vf scale=${WIDTH}:${HEIGHT} /dev/shm/pic.png & echo $! > /dev/shm/convert.pid
    #TTT=$(time ffmpeg -y -loglevel quiet -i "${PATHPIC}/${MEDIA}" -vf scale=${WIDTH}:${HEIGHT} /dev/shm/pic.png)
    #echo "time $TTT"
  else
    cp "${PATHPIC}/${MEDIA}" /dev/shm/pic.png
  fi
else
  cp ~/tty2rpi-pics/000-notavail.png /dev/shm/pic.png
fi

GETFNAM "${PATHVID}" "${MEDIAVID}"
if ([ "${MEDIA%.*}" = "MENU" ] || [ "${MEDIA%.*}" = "MAME-MENU" ] || [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${SOUNDMENU}" = "no" ]; then VLCAUDIO="--no-audio"; fi
if (! [ "${MEDIA%.*}" = "MENU" ] && ! [ "${MEDIA%.*}" = "MAME-MENU" ] && ! [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${SOUNDARCADE}" = "no" ]; then VLCAUDIO="--no-audio"; fi
if (! [ "${MEDIA%.*}" = "MENU" ] && ! [ "${MEDIA%.*}" = "MAME-MENU" ] && ! [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${VIDEOARCADE}" = "no" ]; then PLAYVIDEO="no"; fi
if [ "${PLAYVIDEO}" = "yes" ]; then
  [ -f "${PATHVID}/${MEDIA}" ] && cvlc -f --no-video-title-show --play-and-exit --verbose 0 --vout mmal_vout --aout alsa ${VLCAUDIO} ${VLCPREFEETCH} "${PATHVID}/${MEDIA}"
fi

# Wait for the completion of the convert process
if [ -e /dev/shm/convert.pid ]; then
  while [ -d /proc/$(</dev/shm/convert.pid) ] ; do sleep 0.1; done
  rm /dev/shm/convert.pid
fi
systemctl --user start --quiet tty2rpi-screensaver.timer
feh --quiet --fullscreen /dev/shm/pic.png
