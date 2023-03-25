#!/bin/bash

# https://wiki.batocera.org/launch_a_script#emulationstation_scripting
source ~/configs/emulationstation/scripts/tty2rpi.ini

case ${1} in
  gameStart)
    CORE="${2}"
    [ "${CORE}" = "mame" ] && CORE="$(basename ${5%.*})"
    ;;
  gameStop)
    CORE="BATOCERA-MENU"
    ;;
esac

# tty2rpi part
echo "CMDCOR,${CORE}" > ${TTYDEV}

# gameStart gba libretro mgba /userdata/roms/gba/SpaceTwins.gba
# gameStop gba libretro mgba /userdata/roms/gba/SpaceTwins.gba
