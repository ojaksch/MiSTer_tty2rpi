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
#git -C ${LOCALGITDIR} pull --quiet > /dev/null 2>&1
git -C ${LOCALGITDIR} fetch origin --quiet > /dev/null 2>&1
if [ ${?} -gt 0 ]; then
  git -C ${LOCALGITDIR} clone --quiet https://github.com/ojaksch/MiSTer_tty2rpi
  mv ${LOCALGITDIR}/MiSTer_tty2rpi/{.,}* ${LOCALGITDIR}/ > /dev/null 2>&1
  rm -rf ${LOCALGITDIR}/MiSTer_tty2rpi/
else
  git -C ${LOCALGITDIR} reset --hard origin/main --quiet > /dev/null 2>&1
  git -C ${LOCALGITDIR} clean -xdf --quiet 2>&1
fi
! [ -f ~/.xinitrc-extra ] && touch ~/.xinitrc-extra
sudo rsync -aq ${LOCALGITDIR}/files_rpi/ / > /dev/null 2>&1
sudo rsync -aq /tmp/home/tty2rpi/ ~/
sudo chown -R $(id -un 1000): $(getent passwd "1000" | awk -F ":" '{print $6}')
sudo chown root: /etc/X11/xorg.conf.d/10-monitor.conf  /etc/rc.local  /etc/NetworkManager/system-connections/*
sudo ln -sf ~/update_tty2rpi.sh /usr/local/bin/
sudo chmod 600 /etc/NetworkManager/system-connections/*
sudo chmod 777 /tmp
if ! [ -s /etc/systemd/system/splashscreen-startup.service ]; then
  sudo cp /etc/systemd/system/splashscreen-startup.service.template /etc/systemd/system/splashscreen-startup.service
  sudo systemctl enable splashscreen-startup.service
fi
if ! [ -s /etc/systemd/system/splashscreen-shutdown.service ]; then
  sudo cp /etc/systemd/system/splashscreen-shutdown.service.template /etc/systemd/system/splashscreen-shutdown.service
  sudo systemctl enable splashscreen-shutdown.service
fi
# The next block can be remove in some months
if [ -f /etc/systemd/system/splashscreen.service ]; then
  sudo systemctl disable splashscreen.service
  sudo rm /etc/systemd/system/splashscreen.service
fi
[ -z "${SSH_TTY}" ] && echo -e "${fgreen}Press any key to continue\n${freset}"
