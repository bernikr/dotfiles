if [[ $- = *i* ]]; then # interactive shell only
  alias ll='ls -l'
  alias l='ls -lA'

  alias dc='docker compose'
  alias dcu='docker compose up -d --pull always --remove-orphans'
  alias dcb='docker compose --progress=plain build'
  alias dcub='docker compose up -d --pull always --build --remove-orphans'
  alias dcbu=dcub
  alias dcl='docker compose logs -f -n 100'
  alias dcul='dcu && dcl'
  alias dcr='docker compose restart'

  alias rsync='rsync --info=progress2'

  alias dive="docker run -ti --rm  -v /var/run/docker.sock:/var/run/docker.sock docker.io/wagoodman/dive"

  alias t="tmux -u new-session -A -s default"
fi
