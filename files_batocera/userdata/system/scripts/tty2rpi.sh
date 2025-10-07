#!/bin/bash

# https://wiki.batocera.org/launch_a_script#emulationstation_scripting

source /userdata/system/scripts/tty2rpi.ini

case ${1} in
  gameStart)
    CORENAME="${2}"
    GAMENAME="$(basename ${5%.*})"
    if [ "${CORENAME}" = "mame" ] && [ "${TTYPICNAME}" = "core" ]; then CORENAME="$(basename ${5%.*})"; fi
    if [ "${CORENAME}" = "mame" ] && [ "${TTYPICNAME}" = "game" ]; then CORENAME="-"; fi
    ;;
  gameStop)
    CORENAME="BATOCERA-MENU"
    GAMENAME="BATOCERA-MENU"
    ;;
esac

# tty2rpi part
[ "${TTYPICNAME}" = "core" ] && echo "CMDCOR§-§${CORENAME}" > ${TTYDEV}
[ "${TTYPICNAME}" = "game" ] && echo "CMDCOR§${CORENAME^^}§${CORENAME^^}/${GAMENAME}" > ${TTYDEV}

# gameStart gba libretro mgba /userdata/roms/gba/SpaceTwins.gba
# gameStop gba libretro mgba /userdata/roms/gba/SpaceTwins.gba

echo "${DATENOW}: this is tty2rpi with core »${CORENAME}« and gamename »${GAMENAME}«" >> /tmp/tty2rpi-debug
echo "Batocera command: $@" >> /tmp/tty2rpi-debug
echo "------------------------------------------------------------------------------------------------" >> /tmp/tty2rpi-debug
