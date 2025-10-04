#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini

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
  cp --update ${TTY2RPIPICS}/tty2rpi.png /dev/shm
  systemctl --user daemon-reload
fi

if [ "${SCREENSAVER}" = "no" ] && [ $(systemctl is-active --user tty2rpi-screensaver.timer) = "active" ]; then
  systemctl --user stop tty2rpi-screensaver.timer
fi

while true; do
#  inotifywait -qq -e modify ${SOCKET}
  INOCHANGE=$(inotifywait --quiet --event modify,close_write,delete,moved_to --recursive --csv ${SOCKET} "${PATHPIC}" "${PATHVID}")
  INOFILE="$(echo ${INOCHANGE} | cut -d "," -f 1)"
  # logger "inotify: something changed: $INOCHANGE -- (${INOFILE%/})"
  [ "${INOFILE%/}" = "${PATHPIC}" ] && updatedb -l 0 -U ${HOME} -o /dev/shm/tmp/mediadb &
  [ "${INOFILE%/}" = "${PATHVID}" ] && updatedb -l 0 -U ${HOME} -o /dev/shm/tmp/mediadb &
  if [ "$(echo "${INOCHANGE}" | cut -d "," -f 1)" = "/dev/shm/tty2rpi.socket" ]; then
    COMMAND=$(tail -n1 ${SOCKET} | tr -d '\0')
    if [ "${COMMAND}" != "NIL" ]; then					# NIL is a "hello?" command
      KILLPID "${VIDEOPLAYER}"
      sync ${SOCKET}
      ~/tty2rpi-scripts/tty2rpi.sh & echo $! > ${PID_TTY2RPI}
    fi
  fi
done
