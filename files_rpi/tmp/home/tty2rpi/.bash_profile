[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -z "${SSH_TTY}" ]; then
  if [[ $(fgconsole 2>/dev/null) == 1 ]]; then
    [ "${DISPLAYMNGR}" = "xorg" ] && exec startx -- -nocursor vt1 &> /dev/null
    [ "${DISPLAYMNGR}" = "wayland" ] && exec labwc &> /dev/null
  fi
fi
