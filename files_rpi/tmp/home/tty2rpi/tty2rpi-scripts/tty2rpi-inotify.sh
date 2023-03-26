#!/bin/bash

source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

if [ "${SCREENSAVER}" = "yes" ]; then
  SCREENSAVER_START=$((SCREENSAVER_START*60))
echo "[Unit]
Description=Run the tty2rpi screensaver

[Timer]
OnActiveSec=${SCREENSAVER_START}
OnUnitActiveSec=${SCREENSAVER_IVAL}
AccuracySec=1ms

[Install]
WantedBy=timers.target
" > ~/.config/systemd/user/tty2rpi-screensaver.timer
systemctl --user daemon-reload
fi

while true; do
  inotifywait -qq -e modify ${SOCKET}
  COMMAND=$(tail -n1 ${SOCKET} | tr -d '\0')
  if [ "${COMMAND}" != "NIL" ]; then					# NIL is a "hello?" command
    ! [ "$(<${PID_TTY2RPI})" = "0" ] && KILLPID $(<${PID_TTY2RPI})
    KILLPID "feh"
    KILLPID "vlc"
    sync ${SOCKET}
    ~/tty2rpi-scripts/tty2rpi.sh & echo $! > ${PID_TTY2RPI}
  fi
done
