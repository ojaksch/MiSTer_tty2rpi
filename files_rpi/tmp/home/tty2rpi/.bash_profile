[[ -f ~/.bashrc ]] && . ~/.bashrc
source ~/tty2rpi.ini
source ~/tty2rpi-user.ini
if [ -z "${SSH_TTY}" ]; then
  if [[ $(fgconsole 2>/dev/null) == 1 ]]; then
    [ $(pidof fim) ] && sudo systemctl stop splashscreen-startup.service
      exec startx -- -nocursor vt1 &> /dev/null
  fi
fi
