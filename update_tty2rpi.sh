#!/bin/bash

REPOSITORY_URL="https://raw.githubusercontent.com/ojaksch/MiSTer_tty2rpi/main"
REPOSITORY_URL2="https://www.tty2tft.de/MiSTer_tty2rpi"
NODEBUG="-q -o /dev/null"
[ -e ~/tty2rpi.ini ] && . ~/tty2rpi.ini
[ -e ~/tty2rpi-user.ini ] && . ~/tty2rpi-user.ini

echo -e "\n +---------+";
echo -e " | ${fblue}tty2rpi${freset} |---[]";
echo -e " +---------+\n";

check4error() {
  case "${1}" in
    0) ;;
    1) echo -e "${fyellow}wget: ${fred}Generic error code.${freset}" ;;
    2) echo -e "${fyellow}wget: ${fred}Parse error---for instance, when parsing command-line options, the .wgetrc or .netrc..." ;;
    3) echo -e "${fyellow}wget: ${fred}File I/O error.${freset}" ;;
    4) echo -e "${fyellow}wget: ${fred}Network failure.${freset}" ;;
    5) echo -e "${fyellow}wget: ${fred}SSL verification failure.${freset}" ;;
    6) echo -e "${fyellow}wget: ${fred}Username/password authentication failure.${freset}" ;;
    7) echo -e "${fyellow}wget: ${fred}Protocol errors.${freset}" ;;
    8) echo -e "${fyellow}wget: ${fred}Server issued an error response.${freset}" ;;
    *) echo -e "${fred}Unexpected and uncatched error.${freset}" ;;
  esac
  ! [ "${1}" = "0" ] && exit "${1}"
}

# Which is the primary interface?
for IFACE in $(ls /sys/class/net); do
  if [ $(cat /sys/class/net/${IFACE}/operstate) = "up" ]; then
    MAC=$(cat /sys/class/net/${IFACE}/address)
    break
  fi
done

# Update the updater if neccessary
wget ${NODEBUG} --no-cache "${REPOSITORY_URL}/update_tty2rpi.sh" -O /tmp/update_tty2rpi.sh
check4error "${?}"
chmod +x /tmp/update_tty2rpi.sh
cmp -s /tmp/update_tty2rpi.sh ~/update_tty2rpi.sh
if [ "${?}" -gt "0" ] && [ -s /tmp/update_tty2rpi.sh ]; then
    echo -e "${fyellow}Downloading Updater-Update ${fmagenta}${PICNAME}${freset}"
    mv -f /tmp/update_tty2rpi.sh ~/update_tty2rpi.sh
    exec ~/update_tty2rpi.sh
    exit 255
else
    rm /tmp/update_tty2rpi.sh
fi

# Check and update INI files if neccessary
wget ${NODEBUG} --no-cache "${REPOSITORY_URL}/files_rpi/tmp/home/tty2rpi/tty2rpi.ini" -O /tmp/tty2rpi.ini
check4error "${?}"
. /tmp/tty2rpi.ini
cmp -s /tmp/tty2rpi.ini ~/tty2rpi.ini
if [ "${?}" -gt "0" ]; then
    mv /tmp/tty2rpi.ini ~/tty2rpi.ini
    . ~/tty2rpi.ini
fi

! [ -e ~/tty2rpi-user.ini ] && touch ~/tty2rpi-user.ini

wget ${NODEBUG} ${REPOSITORY_URL2}/MAC.html?${MAC}
wget ${NODEBUG} --no-cache "${REPOSITORY_URL}/update_tty2rpi_script.sh" -O "${SCRIPTNAME}"
check4error "${?}"
[ -s "${SCRIPTNAME}" ] && bash "${SCRIPTNAME}" "${@}"
[ -f "${SCRIPTNAME}" ] && rm "${SCRIPTNAME}"

date +%s > ~/last_update
exit 0
