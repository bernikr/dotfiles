#!/bin/sh
set -eu

# 1. Install prerequisites (Bash, curl, git, sudo)
if ! command -v bash >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then
    echo "==> Installing prerequisites..."
    if command -v apt-get >/dev/null 2>&1; then
        apt-get update && apt-get install -y bash curl git sudo
    elif command -v apk >/dev/null 2>&1; then
        apk add --no-cache bash curl git sudo
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y bash curl git sudo
    elif command -v pacman >/dev/null 2>&1; then
        pacman -Sy --noconfirm bash curl git sudo
    fi
fi

# 2. Handle root account: Homebrew requires a non-root user
IS_ROOT=0
if [ "$(id -u)" -eq 0 ]; then
    IS_ROOT=1
    echo "==> Running as root. Setting up dedicated 'linuxbrew' user..."

    # Create linuxbrew user if missing
    if ! id -u linuxbrew >/dev/null 2>&1; then
        if command -v useradd >/dev/null 2>&1; then
            useradd -m -s /bin/bash linuxbrew
        elif command -v adduser >/dev/null 2>&1; then
            adduser -D -s /bin/bash linuxbrew
        fi
    fi

    # Grant passwordless sudo to linuxbrew user (if sudoers exists)
    if [ -d "/etc/sudoers.d" ]; then
        echo "linuxbrew ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/linuxbrew
        chmod 0440 /etc/sudoers.d/linuxbrew
    fi

    # Prepare directories with correct ownership
    mkdir -p /home/linuxbrew/.linuxbrew
    chown -R linuxbrew:linuxbrew /home/linuxbrew
fi

# Helper function to run commands as linuxbrew (if root) or directly (if normal user)
run_as_brew_user() {
    CMD="$1"
    if [ "$IS_ROOT" -eq 1 ]; then
        su -l linuxbrew -c "$CMD"
    else
        sh -c "$CMD"
    fi
}

# 3. Install Homebrew if missing
if [ ! -f "/home/linuxbrew/.linuxbrew/bin/brew" ] && [ ! -f "/opt/homebrew/bin/brew" ] && [ ! -f "/usr/local/bin/brew" ]; then
    echo "==> Installing Homebrew..."
    run_as_brew_user 'NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
fi

# 4. Write Brewfile to a temporary file
BREWFILE="/tmp/chezmoi_brewfile"
cat <<'EOF' > "$BREWFILE"

brew "nano"
brew "tmux"
brew "bat"
brew "jq"
brew "uv"
brew "yazi"
brew "magic-wormhole"
brew "pv"
brew "bash-completion@2"

EOF
chmod 644 "$BREWFILE"

echo "==> Installing packages from Brewfile..."

# 5. Run brew bundle as the appropriate user
run_as_brew_user '
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    brew bundle --file="'"$BREWFILE"'"
'

# Clean up Brewfile
rm -f "$BREWFILE"

# 6. Put Homebrew into root's current shell environment so you can use the binaries immediately
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo "==> Package installation complete."
