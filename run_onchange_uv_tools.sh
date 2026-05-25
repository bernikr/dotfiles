#!/bin/sh

if ! command -v uv >/dev/null 2>&1; then
    echo "uv is not installed. Installing..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "uv is already installed."
fi

uv tool install yazi-bin
uv tool install magic-wormhole
