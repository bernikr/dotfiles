#!/usr/bin/env bash
set -euo pipefail

echo "==> Checking Homebrew installation..."

# 1. Install Homebrew if it doesn't exist
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. Put brew into PATH for the current shell session
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo "==> Installing packages from Brewfile..."

# 3. Install packages via Brew bundle (idempotent & supports taps, brews, casks)
brew bundle --file=/dev/stdin <<EOF

brew "nano"
brew "tmux"
brew "bat"
brew "jq"
brew "uv"
brew "yazi"
brew "magic-wormhole"

EOF

echo "==> Package installation complete."
