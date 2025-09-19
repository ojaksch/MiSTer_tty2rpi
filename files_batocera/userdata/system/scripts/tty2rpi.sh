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
[ "${TTYPICNAME}" = "game" ] && echo "CMDCOR§${CORENAME^^}§${GAMENAME}" > ${TTYDEV}

# gameStart gba libretro mgba /userdata/roms/gba/SpaceTwins.gba
# gameStop gba libretro mgba /userdata/roms/gba/SpaceTwins.gba
