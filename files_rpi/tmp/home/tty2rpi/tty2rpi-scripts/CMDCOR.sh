#!/bin/bash

. ~/tty2rpi.ini
. ~/tty2rpi-user.ini
. ~/tty2rpi-screens.ini
. ~/tty2rpi-functions.ini
#. <(cat ~/tty2rpi*.ini)

MEDIAPIC="$(echo ${COMMANDLINE[@]} | cut -d " " -f 2)"
MEDIA="$(echo ${COMMANDLINE[@]} | cut -d " " -f 2)"
if [ "${MEDIA}" != "-" ]; then
  logger "Socket got CORE »${MEDIA}«"
  GETFNAM "${PATHPIC}" "${MEDIAPIC}"
  [ "${SCREENSAVER}" = "yes" ] && cp "${MEDIA}" "${TMPDIR}/CORE.png"
else
  [ -f "${TMPDIR}/CORE.png" ] && rm "${TMPDIR}/CORE.png"
fi

MEDIAPIC="$(echo ${COMMANDLINE[@]} | cut -d " " -f 3-)"
MEDIAVID="$(echo ${COMMANDLINE[@]} | cut -d " " -f 3-)"

MEDIA="$(echo ${COMMANDLINE[@]} | cut -d " " -f 3-)"
logger "Socket got GAME »${MEDIA}«"
echo "${MEDIA}" > "${TMPDIR}/tmp/corename"
[ "${SCREENSAVER}" = "yes" ] && systemctl --user stop --quiet tty2rpi-screensaver.timer

ALTFILES="$(find "${TMPDIR}" -name "*_alt*")"
if [ "${SCREENSAVER}" = "yes" ] && [ -n "${ALTFILES}" ]; then
  rm ${TMPDIR}/*_alt*
fi

if [ "${VIDEOARCADE}" = "yes" ]; then
  GETFNAM "${PATHVID}" "${MEDIAVID}"
  if ([ "${MEDIA%.*}" = "MENU" ] || [ "${MEDIA%.*}" = "MAME-MENU" ] || [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${SOUNDMENU}" = "no" ]; then AUDIOYESNO="--no-audio"; fi
  if (! [ "${MEDIA%.*}" = "MENU" ] && ! [ "${MEDIA%.*}" = "MAME-MENU" ] && ! [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${SOUNDARCADE}" = "no" ]; then AUDIOYESNO="--no-audio"; fi
  if (! [ "${MEDIA%.*}" = "MENU" ] && ! [ "${MEDIA%.*}" = "MAME-MENU" ] && ! [ "${MEDIA%.*}" = "MISTER-MENU" ]) && [ "${VIDEOARCADE}" = "no" ]; then PLAYVIDEO="no"; fi
  if [ "${PLAYVIDEO}" = "yes" ]; then
    if [ -f "${MEDIA}" ]; then
      case "${VIDEOPLAYER}" in
	"vlc")		cvlc --verbose 0 --no-lua -f --no-video-title-show --play-and-exit --vout "${VLCVIDEO}" --aout alsa "${AUDIOYESNO}" "${VLCPREFEETCH}" "${MEDIA}" ;;
	"mpv")		mpv --no-config --really-quiet --fullscreen "${AUDIOYESNO}" "${MEDIA}" ;;
	"mplayer")	AUDIOYESNO="-nosound" ; mplayer -really-quiet -nolirc -fs -vo gl_nosw "${AUDIOYESNO}" "${MEDIA}" ;;
      esac
    fi
  fi
fi

if [ -s "${MAMEMARQUEES}" ]; then
  7za e -y -bsp0 -bso0 -so "${MAMEMARQUEES}" "${MEDIAPIC}.*" > "${TMPDIR}/pic.png.tmp"
  [ -s "${TMPDIR}/pic.png.tmp" ] && logger "Found a picture »${MEDIAPIC}« in MAME Marquees"
fi
if ! [ -s "${TMPDIR}/pic.png.tmp" ]; then
  GETFNAM "${PATHPIC}" "${MEDIAPIC}"
  if ([ "${FNAMSEARCH}" = "MENU" ] || [ "${FNAMSEARCH}" = "MAME-MENU" ] || [ "${FNAMSEARCH}" = "MISTER-MENU" ]); then cp "${MEDIA}" "${TMPDIR}/pic.png"; fi
  if [ -f "${MEDIA}" ]; then
    PICSIZE=$(identify -format '%wx%h' "${MEDIA}")
    if [ "${PICSIZE}" != "${WIDTH}x${HEIGHT}" ] && [ "${KEEPASPECTRATIO}" != "no" ]; then
      if [ "${KEEPASPECTRATIO}" = "yes" ]; then
	ffmpeg -y -loglevel quiet -i "${MEDIA}" -vf scale=w=${WIDTH}:h=${HEIGHT}:force_original_aspect_ratio=increase "${TMPDIR}/pic.png" & echo $! > "${TMPDIR}/tmp/convert.pid"
      elif [ "${KEEPASPECTRATIO}" = "no" ]; then
	ffmpeg -y -loglevel quiet -i "${MEDIA}" -vf scale=${WIDTH}:${HEIGHT} "${TMPDIR}/pic.png" & echo $! > "${TMPDIR}/tmp/convert.pid"
      elif [ "${KEEPASPECTRATIO}" = "x" ]; then
	ffmpeg -y -loglevel quiet -i "${MEDIA}" -vf scale=-1:${HEIGHT} "${TMPDIR}/pic.png" & echo $! > "${TMPDIR}/tmp/convert.pid"
      elif [ "${KEEPASPECTRATIO}" = "y" ]; then
	ffmpeg -y -loglevel quiet -i "${MEDIA}" -vf scale=${WIDTH}:-1 "${TMPDIR}/pic.png" & echo $! > "${TMPDIR}/tmp/convert.pid"
      fi
    else
      cp "${MEDIA}" "${TMPDIR}/pic.png"
    fi
  else
    if [ "${SHOWMISSPIC}" = "yes" ]; then
      # Show "not found"
      cp "${TTY2RPIPICS}/000-notavail.png" "${TMPDIR}/pic.png"
      logger "but no matching medium found"
    else
      # No Media found but doesn't show it
      ! [ -s "${TMPDIR}/pic.png.tmp" ] && logger "but no matching medium found"
      [ -s "${TMPDIR}/pic.png.tmp" ] && mv "${TMPDIR}/pic.png.tmp" "${TMPDIR}/pic.png"
    fi
  fi
fi



if [ "${SCREENSAVER}" = "yes" ] && [ -n "${ALTENTRYS}" ]; then
  if [ -n "${FNAMFOUND}" ]; then
    #logger "fnamfound:$FNAMFOUND"
    #logger "altentrys:$ALTENTRYS"
    cp "${FNAMFOUND}" "${TMPDIR}/pic.png"
    readarray -t ALTFILES <<<"${ALTENTRYS}"
    for ALTFILE in "${ALTFILES[@]}"; do
#      echo "${ALTFILE}"
      cp "${ALTFILE[@]}" "${TMPDIR}"
    done
  fi
fi



# Wait for the completion of the convert process
if [ -e "${TMPDIR}/tmp/convert.pid" ]; then
  while [ -d /proc/$(<"${TMPDIR}/tmp/convert.pid") ] ; do sleep 0.1; done
  rm "${TMPDIR}/tmp/convert.pid"
fi

[ "${SCREENSAVER}" = "yes" ] && systemctl --user start --quiet tty2rpi-screensaver.timer
if [ "${SCREENSAVER}" = "no" ] && [ $(systemctl is-active --user tty2rpi-screensaver.timer) = "active" ]; then
  systemctl --user stop tty2rpi-screensaver.timer
fi

if [ -f "${TMPDIR}/tmp/screesaver.pid" ]; then
  if [ "$(<"${TMPDIR}/tmp/screesaver.pid")" -gt "0" ]; then
    rm "${TMPDIR}/tmp/screesaver.pid"
    KILLPID feh
    feh --quiet --fullscreen --auto-zoom "${TMPDIR}/pic.png" &
  fi
fi
[ -z "$(pidof feh)" ] && feh --quiet --fullscreen --auto-zoom "${TMPDIR}/pic.png" &
