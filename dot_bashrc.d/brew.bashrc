# 1. Ensure Homebrew environment is set up first
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# 2. Source all completions installed by Homebrew
if [[ -d "/home/linuxbrew/.linuxbrew/etc/bash_completion.d" ]]; then
  for completion_script in "/home/linuxbrew/.linuxbrew/etc/bash_completion.d/"*; do
    [[ -r "$completion_script" ]] && source "$completion_script"
  done
  unset completion_script
fi
