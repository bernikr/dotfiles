if [[ $- = *i* ]]; then # only in interactive shell
  source ~/.custom/sensible.bash
  source ~/.custom/commacd.sh
  if [ "$TERM" != "linux" ]; then
    source ~/.custom/pureline/pureline ~/.pureline.conf
  fi
fi
