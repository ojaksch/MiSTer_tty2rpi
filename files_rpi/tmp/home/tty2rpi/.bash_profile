[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -z "${SSH_TTY}" ]; then
  if [[ $(fgconsole 2>/dev/null) == 1 ]]; then
      exec startx -- -nocursor vt1 &> /dev/null
  fi
fi
