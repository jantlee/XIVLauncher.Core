#!/bin/bash
set -e

echo "=== XIVLauncher.Core Patched Installer ==="
echo ""

# Install .NET SDK if not present
if ! command -v dotnet &> /dev/null; then
    echo "Installing .NET SDK..."
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 10.0
fi
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$PATH:$HOME/.dotnet"

# Clone or update repo
REPO_DIR="$HOME/XIVLauncher.Core"
if [ -d "$REPO_DIR" ]; then
    echo "Updating existing repo..."
    cd "$REPO_DIR"
    git fetch origin
else
    echo "Cloning repo..."
    git clone https://github.com/jantlee/XIVLauncher.Core.git "$REPO_DIR"
    cd "$REPO_DIR"
fi

git checkout patch-retry
git submodule update --init --recursive

# Build
echo "Building..."
dotnet publish src/XIVLauncher.Core -r linux-x64 -c Release --self-contained -o "$HOME/xlcore-patched"

echo ""
echo "=== Build complete ==="
echo "Patched binary is at ~/xlcore-patched"
echo ""
echo "To install, run:"
echo "  cp ~/xlcore-patched/XIVLauncher.Core ~/.xlcore/XIVLauncher.Core.bak"
echo "  cp ~/xlcore-patched/* ~/.xlcore/"
