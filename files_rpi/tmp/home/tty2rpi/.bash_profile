[[ -f ~/.bashrc ]] && . ~/.bashrc
source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
source ~/tty2rpi-screens.ini
source ~/tty2rpi-functions.ini

if [ -z "${SSH_TTY}" ]; then
  if [[ $(fgconsole 2>/dev/null) == 1 ]]; then
      exec startx -- -nocursor vt1 &> /dev/null
  fi
fi
