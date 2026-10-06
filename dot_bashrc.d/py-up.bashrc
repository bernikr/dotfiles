function py-up() (
  set  -x
  uv tool upgrade --all
  uv-bump
  uv sync --upgrade
  actions-up --yes
  prek update
  prek run -a
  prek run -a
)

