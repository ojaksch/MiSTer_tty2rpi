#!/bin/bash

. ~/tty2rpi.ini
. ~/tty2rpi-user.ini
. ~/tty2rpi-screens.ini
. ~/tty2rpi-functions.ini
#. <(cat ~/tty2rpi*.ini)

if [ "${SCREENSAVER}" = "yes" ]; then
  SCREENSAVER_START=$((SCREENSAVER_START*60))
echo "[Unit]
Description=Run the tty2rpi screensaver

[Timer]
OnActiveSec=${SCREENSAVER_START}
OnUnitActiveSec=$((SCREENSAVER_IVAL-2))
AccuracySec=1ms

[Install]
WantedBy=timers.target
" > ~/.config/systemd/user/tty2rpi-screensaver.timer
  cp --update "${TTY2RPIPICS}/tty2rpi.png" "${TMPDIR}"
  systemctl --user daemon-reload
fi

if [ "${SCREENSAVER}" = "no" ] && [ $(systemctl is-active --user tty2rpi-screensaver.timer) = "active" ]; then
  systemctl --user stop tty2rpi-screensaver.timer
fi

while true; do
  INOCHANGE=$(inotifywait --quiet --event modify,close_write,delete,moved_to --recursive --csv "${SOCKET}" "${PATHPIC}" "${PATHVID}")
  INOFILE="$(echo ${INOCHANGE} | cut -d "," -f 1)"
  sync "${SOCKET}"
  [ "${DEBUG}" = "yes" ] && logger "inotify: something has changed: ${INOCHANGE} -- (${INOFILE%/})"
  if [ "$(echo "${INOCHANGE}" | cut -d "," -f 1)" = "${SOCKET}" ]; then
    COMMAND=$(tail -n1 "${SOCKET}" | tr -d '\0' | sed 's/\x55\xFF\x02\xFE\xD4\x02\*//g')		# Remove NULL and some "MiSTer reboot" character
    [ "${COMMAND}" != "tty2rpi-screensaver" ] && systemctl --user stop tty2rpi-screensaver.timer
    if [ "${COMMAND}" != "NIL" ]; then					# NIL is a "hello?" command
      KILLPID "${VIDEOPLAYER}"
      sync "${SOCKET}"
      ~/tty2rpi-scripts/tty2rpi.sh & echo $! > "${PID_TTY2RPI}"
    fi
  else
    updatedb -l 0 -U "${HOME}" -o "${TMPDIR}/tmp/mediadb" &
  fi
done
