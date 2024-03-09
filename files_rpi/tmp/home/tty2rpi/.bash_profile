[[ -f ~/.bashrc ]] && . ~/.bashrc
source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
if [ -z "${SSH_TTY}" ]; then
  if [[ $(fgconsole 2>/dev/null) == 1 ]]; then
    [ $(pidof fim) ] && sudo systemctl stop splashscreen-startup.service
    if [ "${FBUFDEV}" = "yes" ]; then
      source ~/tty2rpi-screens.ini
      clear
      PS1=""
      tput civis
      if [ "${FBUFDEV}" = "yes" ] && [ "${USEFBCP}" = "yes" ] && [ -e /home/tty2rpi/fbcp-ili9341/build/fbcp-ili9341 ]; then
	sudo /home/tty2rpi/fbcp-ili9341/build/fbcp-ili9341 > /dev/null 2>&1 &
      fi
      /home/tty2rpi/.config/openbox/autostart &
    else
      #[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- -nocursor vt1 &> /dev/null
      exec startx -- -nocursor vt1 &> /dev/null
    fi
  fi
fi
