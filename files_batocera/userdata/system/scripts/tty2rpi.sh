#!/bin/bash

source ~/configs/emulationstation/scripts/tty2rpi.ini

case ${1} in
  gameStart)    CORE="${2}" ;;
  gameStop)     CORE="BATOCERA-MENU" ;;
esac

# tty2rpi part
echo "CMDCOR,${CORE}" > ${TTYDEV}

# gameStart gba libretro mgba /userdata/roms/gba/SpaceTwins.gba
# gameStop gba libretro mgba /userdata/roms/gba/SpaceTwins.gba
