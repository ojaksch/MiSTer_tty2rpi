#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

MEDIAPIC="$(echo ${COMMANDLINE[@]} | cut -d " " -f 2-)"
MEDIAVID="$(echo ${COMMANDLINE[@]} | cut -d " " -f 2-)"

MEDIA="$(echo ${COMMANDLINE[@]} | cut -d " " -f 2-)"
logger "Socket got »${MEDIA}«"
echo "${MEDIA}" > /dev/shm/corename
[ "${SCREENSAVER}" = "yes" ] && systemctl --user stop --quiet tty2rpi-screensaver.timer

GETFNAM "${PATHPIC}" "${MEDIAPIC}"
if ([ "${MEDIA%.*}" = "MENU" ] || [ "${MEDIA%.*}" = "MAME-MENU" ] || [ "${MEDIA%.*}" = "MISTER-MENU" ]); then cp "${PATHPIC}/${MEDIA}" /dev/shm; fi
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
  [ -s "${MAMEMARQUEES}" ] && 7za e -y -bsp0 -bso0 -so "${MAMEMARQUEES}" "${MEDIAPIC}.png" > /dev/shm/pic.png
  [ -s /dev/shm/pic.png ] || cp ~/tty2rpi-pics/000-notavail.png /dev/shm/pic.png
fi

GETFNAM "${PATHVID}" "${MEDIAVID}"
if ([ "${MEDIA%.*}" = "MENU" ] || [ "${MEDIA%.*}" = "MAME-MENU" ] || [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${SOUNDMENU}" = "no" ]; then VLCAUDIO="--no-audio"; fi
if (! [ "${MEDIA%.*}" = "MENU" ] && ! [ "${MEDIA%.*}" = "MAME-MENU" ] && ! [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${SOUNDARCADE}" = "no" ]; then VLCAUDIO="--no-audio"; fi
if (! [ "${MEDIA%.*}" = "MENU" ] && ! [ "${MEDIA%.*}" = "MAME-MENU" ] && ! [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${VIDEOARCADE}" = "no" ]; then PLAYVIDEO="no"; fi
if [ "${PLAYVIDEO}" = "yes" ]; then
  if [ "${FBUFDEV}" = "yes" ]; then
    source ~/tty2rpi-screens.ini
    [ -f "${PATHVID}/${MEDIA}" ] && TERM=xterm-256color mplayer -really-quiet -vo fbdev2:${FBDEVICE} -vf scale=${WIDTH}:-2 -aspect 16:9 -nosound -nolirc "${PATHVID}/${MEDIA}"
  else
    [ -f "${PATHVID}/${MEDIA}" ] && cvlc -f --no-video-title-show --play-and-exit --verbose 0 --vout ${VLCVIDEO} --aout alsa ${VLCAUDIO} ${VLCPREFEETCH} "${PATHVID}/${MEDIA}"
  fi
fi

# Wait for the completion of the convert process
if [ -e /dev/shm/convert.pid ]; then
  while [ -d /proc/$(</dev/shm/convert.pid) ] ; do sleep 0.1; done
  rm /dev/shm/convert.pid
fi

[ "${SCREENSAVER}" = "yes" ] && systemctl --user start --quiet tty2rpi-screensaver.timer
if [ "${SCREENSAVER}" = "no" ] && [ $(systemctl is-active --user tty2rpi-screensaver.timer) = "active" ]; then
  systemctl --user stop tty2rpi-screensaver.timer
fi

if [ "${FBUFDEV}" = "yes" ]; then
  FRAMEBUFFER="${FBDEVICE}" fim --autozoom --quiet --output-device fb /dev/shm/pic.png > /dev/null 2>&1
else
  feh --quiet --fullscreen /dev/shm/pic.png
fi
