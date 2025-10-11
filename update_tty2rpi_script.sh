#!/bin/bash

! [ -e ~/tty2rpi-user.ini ] && touch ~/tty2rpi-user.ini
source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

#LASTENTRY=$(grep "CMDCOR" "${SOCKET}" | tail -n1)
systemctl --user stop tty2rpi-inotify.service
[ $(systemctl is-active --user tty2rpi-screensaver.timer) = "active" ] && systemctl --user stop tty2rpi-screensaver.timer
KILLPID feh
cp "${TMPDIR}/pic.png" "${TMPDIR}/tmp/pictmp.png"
cp "${TTY2RPIPICS}/update.png" "${TMPDIR}/pic.png"
feh --quiet --fullscreen --auto-zoom "${TTY2RPIPICS}/update.png" &

# Fetch -apt install- line from GitHub and silently install possible new packages
echo "Checking for and installing missing packages..."
APTUPD=$(wget -q ${REPOSITORY_URL}/1-Setup-Raspberry_Pi.md -O - | grep -m1 "sudo apt install mc")
APTUPD=$(echo ${APTUPD} | sed 's/apt install/apt -q=3 install/')
${APTUPD}

echo "Updating tty2rpi..."
! [ -d ${LOCALGITDIR} ] && mkdir ${LOCALGITDIR}
git -C ${LOCALGITDIR} fetch origin --quiet > /dev/null 2>&1
if [ ${?} -gt 0 ]; then
  git -C ${LOCALGITDIR} clone --quiet https://github.com/ojaksch/MiSTer_tty2rpi
  mv ${LOCALGITDIR}/MiSTer_tty2rpi/{.,}* ${LOCALGITDIR}/ > /dev/null 2>&1
  rm -rf ${LOCALGITDIR}/MiSTer_tty2rpi/
  [ "${REPOSITORY_URL##*/}" = "testing" ] && git -C ${LOCALGITDIR} checkout origin/testing
else
  git -C ${LOCALGITDIR} reset --hard origin/main --quiet > /dev/null 2>&1
  git -C ${LOCALGITDIR} clean -xdf --quiet 2>&1
  [ "${REPOSITORY_URL##*/}" = "testing" ] && git -C ${LOCALGITDIR} checkout origin/testing
fi
! [ -f ~/.xinitrc-extra ] && touch ~/.xinitrc-extra
TTY2RPIUSER="$(id -un 1000)"
TTY2RPIUSERDIR="$(getent passwd "1000" | awk -F ":" '{print $6}')"
sudo rsync -aq --usermap=*:root --groupmap=*:root ${LOCALGITDIR}/files_rpi/ / > /dev/null 2>&1
sudo rsync -aq --usermap=*:${TTY2RPIUSER} --groupmap=*:${TTY2RPIUSER} /tmp/home/tty2rpi/ ~/
sudo chown -R "${TTY2RPIUSER}:" "${TTY2RPIUSERDIR}"

if [ "$(ls -A /etc/NetworkManager/system-connections/ )" ]; then
  sudo chown root: /etc/NetworkManager/system-connections/*
  sudo chmod 600 /etc/NetworkManager/system-connections/*
fi
sudo ln -sf ~/update_tty2rpi.sh /usr/local/bin/
sudo chmod 777 /tmp
if ! [ -s /etc/systemd/system/splashscreen-startup.service ]; then
  sudo cp /etc/systemd/system/splashscreen-startup.service.template /etc/systemd/system/splashscreen-startup.service
  sudo systemctl --quiet enable splashscreen-startup.service
fi
if ! [ -s /etc/systemd/system/splashscreen-shutdown.service ]; then
  sudo cp /etc/systemd/system/splashscreen-shutdown.service.template /etc/systemd/system/splashscreen-shutdown.service
  sudo systemctl --quiet enable splashscreen-shutdown.service
fi

systemctl --user daemon-reload
systemctl --user start tty2rpi-inotify.service
sleep 1
mv "${TMPDIR}/tmp/pictmp.png" "${TMPDIR}/pic.png"
#KILLPID feh
#[ -z "$(pidof feh)" ] && feh --quiet --fullscreen --auto-zoom "${TMPDIR}/pic.png" &
#echo "${LASTENTRY}" > "${SOCKET}"
#[ -z "${SSH_TTY}" ] && echo -e "${fgreen}Press any key to continue\n${freset}"

# cp ${TMPDIR}/pic.png ${TMPDIR}/tmp/actpic.png
# ${IMconvert} ${TMPDIR}/pic.png -undercolor Black -fill white -pointsize $((${WIDTH}/20)) -gravity South -draw "text 0,$((${HEIGHT}/10)) ' ...Update in progress... '" ${TMPDIR}/tmp/pictmp.png
# mv ${TMPDIR}/tmp/actpic.png ${TMPDIR}/pic.png
