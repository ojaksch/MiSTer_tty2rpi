#!/bin/bash

! [ -e ~/tty2rpi-user.ini ] && touch ~/tty2rpi-user.ini
source ~/tty2rpi.ini
source ~/tty2rpi-user.ini

! [ -d ${LOCALGITDIR} ] && mkdir ${LOCALGITDIR}
git -C ${LOCALGITDIR} pull --quiet > /dev/null 2>&1
if [ ${?} -gt 0 ]; then
  git -C ${LOCALGITDIR} clone --quiet https://github.com/ojaksch/MiSTer_tty2rpi
  mv ${LOCALGITDIR}/MiSTer_tty2rpi/{.,}* ${LOCALGITDIR}/ > /dev/null 2>&1
  rm -rf ${LOCALGITDIR}/MiSTer_tty2rpi/
fi
sudo rsync -aq ${LOCALGITDIR}/files_rpi/ / > /dev/null 2>&1
sudo rsync -aq /tmp/home/tty2rpi/ ~/
sudo chown -R $(id -un 1000): $(getent passwd "1000" | awk -F ":" '{print $6}')
sudo chown root: /etc/X11/xorg.conf.d/10-monitor.conf
sudo chown root: /etc/wpa_supplicant/wpa_supplicant.conf.example
sudo chown root: /etc/rc.local
sudo ln -sf ~/update_tty2rpi.sh /usr/local/bin/

[ -z "${SSH_TTY}" ] && echo -e "${fgreen}Press any key to continue\n${freset}"
