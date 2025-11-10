#!/bin/bash

. ~/tty2rpi.ini
. ~/tty2rpi-user.ini
. ~/tty2rpi-screens.ini
. ~/tty2rpi-functions.ini

# Create Backup
[[ -d /tmp/tty2rpi-info ]] || mkdir -p /tmp/tty2rpi-info/tty2rpi
cp /usr/lib/os-release /tmp/tty2rpi-info/
cp "${TMPDIR}/tmp/tty2rpi.socket" /tmp/tty2rpi-info/
cp "${LOCALGITDIR}/.git/HEAD" /tmp/tty2rpi-info/
cp "${LOCALGITDIR}/.git//FETCH_HEAD" /tmp/tty2rpi-info/
ip a > /tmp/tty2rpi-info/network
[ -e /usr/local/bin/showrpimodel ] && cat /proc/cpuinfo | grep Model | cut -d ":" -f 2 > /tmp/tty2rpi-info/pi-model
rsync -qr --include="*/" --include=".bashrc" --include=".bash_profile" --include=".xinitrc*" --include="*.ini" --include="last_update" --include=".config/**" --include="tty2rpi-scripts/**"
tar -C /tmp/tty2rpi-info/ --zstd -cf "${TMPDIR}/tmp/tty2rpi-backup.tar.zst" .
