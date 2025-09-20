#!/bin/bash

# Setup environment: Python virtualenv and dependencies

# Determine project root
if [[ $(basename $(pwd)) == "scripts" ]]; then
    PROJECT_ROOT=$(pwd)/..
else
    PROJECT_ROOT=$(pwd)
fi

cd "$PROJECT_ROOT" || exit 1

# Create and activate virtual environment
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    py -m venv venv
    source venv/Scripts/activate || . venv/Scripts/activate
else
    python3 -m venv venv
    source venv/bin/activate || . venv/bin/activate
fi

echo "Installing Python dependencies..."
pip install -r server/requirements.txt

echo "Installing client dependencies..."
cd client || exit 1
npm ci
# Ensure 'uv' (from https://astral.sh/uv) is installed; idempotent.
echo "Checking for 'uv' tool..."
if command -v uv >/dev/null 2>&1; then
    echo "uv already installed at: $(command -v uv)"
else
    echo "uv not found — installing via astral.sh installer..."
    UV_INSTALLER_TMP=$(mktemp)
    curl -LsSf https://astral.sh/uv/install.sh -o "$UV_INSTALLER_TMP" && \
    sh "$UV_INSTALLER_TMP" || {
        echo "Warning: uv installation failed" >&2
    }
    rm -f "$UV_INSTALLER_TMP"
fi

# Make sure ~/.local/bin is in PATH for this script/session
export PATH="$HOME/.local/bin:$PATH"
echo "PATH updated for this session: $HOME/.local/bin added."

# Return to project root
cd "$PROJECT_ROOT"
