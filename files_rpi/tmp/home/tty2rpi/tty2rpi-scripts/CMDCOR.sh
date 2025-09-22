#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

MEDIAPIC="$(echo ${COMMANDLINE[@]} | cut -d " " -f 2)"
MEDIA="$(echo ${COMMANDLINE[@]} | cut -d " " -f 2)"
if [ "${MEDIA}" != "-" ]; then
  logger "Socket got CORE »${MEDIA}«"
  GETFNAM "${PATHPIC}" "${MEDIAPIC}"
  [ "${SCREENSAVER}" = "yes" ] && ${IMconvert} "${PATHPIC}/${MEDIAPIC}".* /dev/shm/CORE.png
else
  [ -f /dev/shm/CORE.png ] && rm /dev/shm/CORE.png
fi

MEDIAPIC="$(echo ${COMMANDLINE[@]} | cut -d " " -f 3-)"
MEDIAVID="$(echo ${COMMANDLINE[@]} | cut -d " " -f 3-)"

MEDIA="$(echo ${COMMANDLINE[@]} | cut -d " " -f 3-)"
logger "Socket got GAME »${MEDIA}«"
echo "${MEDIA}" > /dev/shm/corename
[ "${SCREENSAVER}" = "yes" ] && systemctl --user stop --quiet tty2rpi-screensaver.timer

GETFNAM "${PATHPIC}" "${MEDIAPIC}"
if ([ "${FNAMSEARCH}" = "MENU" ] || [ "${FNAMSEARCH}" = "MAME-MENU" ] || [ "${FNAMSEARCH}" = "MISTER-MENU" ]); then cp "${MEDIA}" /dev/shm/pic.png; fi

if [ -f "${MEDIA}" ]; then
  PICSIZE=$(identify -format '%wx%h' "${MEDIA}")
  if [ "${PICSIZE}" != "${WIDTH}x${HEIGHT}" ] && [ -n "${KEEPASPECTRATIO}" ]; then
    if [ "${KEEPASPECTRATIO}" = "yes" ]; then
      ffmpeg -y -loglevel quiet -i "${MEDIA}" -vf scale=w=${WIDTH}:h=${HEIGHT}:force_original_aspect_ratio=increase /dev/shm/pic.png & echo $! > /dev/shm/convert.pid
    elif [ "${KEEPASPECTRATIO}" = "no" ]; then
      ffmpeg -y -loglevel quiet -i "${MEDIA}" -vf scale=${WIDTH}:${HEIGHT} /dev/shm/pic.png & echo $! > /dev/shm/convert.pid
    elif [ "${KEEPASPECTRATIO}" = "x" ]; then
      ffmpeg -y -loglevel quiet -i "${MEDIA}" -vf scale=-1:${HEIGHT} /dev/shm/pic.png & echo $! > /dev/shm/convert.pid
    elif [ "${KEEPASPECTRATIO}" = "y" ]; then
      ffmpeg -y -loglevel quiet -i "${MEDIA}" -vf scale=${WIDTH}:-1 /dev/shm/pic.png & echo $! > /dev/shm/convert.pid
    fi
    #TTT=$(time ffmpeg -y -loglevel quiet -i "${MEDIA}" -vf scale=${WIDTH}:${HEIGHT} /dev/shm/pic.png)
    #echo "time $TTT"
  else
    cp "${MEDIA}" /dev/shm/pic.png
  fi
else
  mv /dev/shm/pic.png /dev/shm/pic.png.tmp
  [ -s "${MAMEMARQUEES}" ] && 7za e -y -bsp0 -bso0 -so "${MAMEMARQUEES}" "${MEDIAPIC}.png" > /dev/shm/pic.png
  if [ "${SHOWMISSPIC}" = "yes" ]; then
    [ -s /dev/shm/pic.png ] || cp ${TTY2RPIPICS}/000-notavail.png /dev/shm/pic.png
  else
    mv /dev/shm/pic.png.tmp /dev/shm/pic.png
  fi
fi

GETFNAM "${PATHVID}" "${MEDIAVID}"
if ([ "${MEDIA%.*}" = "MENU" ] || [ "${MEDIA%.*}" = "MAME-MENU" ] || [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${SOUNDMENU}" = "no" ]; then AUDIOYESNO="--no-audio"; fi
if (! [ "${MEDIA%.*}" = "MENU" ] && ! [ "${MEDIA%.*}" = "MAME-MENU" ] && ! [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${SOUNDARCADE}" = "no" ]; then AUDIOYESNO="--no-audio"; fi
if (! [ "${MEDIA%.*}" = "MENU" ] && ! [ "${MEDIA%.*}" = "MAME-MENU" ] && ! [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${VIDEOARCADE}" = "no" ]; then PLAYVIDEO="no"; fi
if [ "${PLAYVIDEO}" = "yes" ]; then
  if [ "${FBUFDEV}" = "yes" ]; then
    source ~/tty2rpi-screens.ini
    [ -f "${MEDIA}" ] && ffmpeg -loglevel quiet -re -i "${MEDIA}" -an -c:v rawvideo -pix_fmt "${FBPIXFMT}" -f fbdev -vf "scale=w=${WIDTH}:h=${HEIGHT}:force_original_aspect_ratio=decrease,pad=${WIDTH}:${HEIGHT}:(ow-iw)/2:(oh-ih)/2" ${FBDEVICE}
  else
    if [ -f "${MEDIA}" ]; then
      case "${VIDEOPLAYER}" in
	"vlc")		cvlc --verbose 0 --no-lua -f --no-video-title-show --play-and-exit --vout ${VLCVIDEO} --aout alsa ${AUDIOYESNO} ${VLCPREFEETCH} "${MEDIA}" ;;
	"mpv")		mpv --no-config --really-quiet --fullscreen ${AUDIOYESNO} "${MEDIA}" ;;
	"mplayer")	AUDIOYESNO="-nosound" ; mplayer -really-quiet -nolirc -fs -vo gl_nosw ${AUDIOYESNO} "${MEDIA}" ;;
      esac
    fi
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
  feh --quiet --fullscreen --auto-zoom /dev/shm/pic.png
fi
