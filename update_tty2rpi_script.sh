#!/bin/bash

! [ -e ~/tty2rpi-user.ini ] && touch ~/tty2rpi-user.ini
source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

# Fetch -apt install- line from GitHub and silently install possible new packages
echo "Checking for and installing missing packages..."
APTUPD=$(wget -q ${REPOSITORY_URL}/1-Setup-Raspberry_Pi.md -O - | grep -m1 "sudo apt install mc")
APTUPD=$(echo ${APTUPD} | sed 's/apt install/apt -q=3 install/')
${APTUPD}

echo "Updating tty2rpi..."
! [ -d ${LOCALGITDIR} ] && mkdir ${LOCALGITDIR}
git -C ${LOCALGITDIR} fetch origin/testing --quiet > /dev/null 2>&1
if [ ${?} -gt 0 ]; then
  git -C ${LOCALGITDIR} clone --quiet https://github.com/ojaksch/MiSTer_tty2rpi
  mv ${LOCALGITDIR}/MiSTer_tty2rpi/{.,}* ${LOCALGITDIR}/ > /dev/null 2>&1
  rm -rf ${LOCALGITDIR}/MiSTer_tty2rpi/
  git -C ${LOCALGITDIR} checkout origin/testing
else
  git -C ${LOCALGITDIR} reset --hard origin/testing --quiet > /dev/null 2>&1
  git -C ${LOCALGITDIR} clean -xdf --quiet 2>&1
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
# The next block can be remove in some months
if [ -f /etc/systemd/system/splashscreen.service ]; then
  sudo systemctl --quiet disable splashscreen.service
  [ -f /etc/systemd/system/splashscreen.service ] && sudo rm /etc/systemd/system/splashscreen.service
  [ -f /etc/systemd/system/splashscreen.service.template ] && sudo rm /etc/systemd/system/splashscreen.service.template
fi
[ -z "${SSH_TTY}" ] && echo -e "${fgreen}Press any key to continue\n${freset}"
