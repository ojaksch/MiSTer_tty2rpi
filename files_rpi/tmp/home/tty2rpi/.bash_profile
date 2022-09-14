[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- -nocursor vt1 &> /dev/null
