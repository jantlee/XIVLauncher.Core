#!/bin/bash
set -e

if ! command -v dotnet &> /dev/null; then
    echo "Installing .NET SDK..."
    curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 10.0
fi
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$PATH:$HOME/.dotnet"

REPO_DIR="$HOME/XIVLauncher.Core"
if [ -d "$REPO_DIR" ]; then
    cd "$REPO_DIR"
    git fetch origin
else
    git clone https://github.com/jantlee/XIVLauncher.Core.git "$REPO_DIR"
    cd "$REPO_DIR"
fi

git checkout patch-retry
git submodule update --init --recursive

dotnet publish src/XIVLauncher.Core -r linux-x64 -c Release --self-contained -o "$HOME/xlcore-patched"

XLM_DIR="$HOME/.local/share/Steam/compatibilitytools.d/XLM/xlcore"
if [ -d "$XLM_DIR" ]; then
    cp "$HOME/xlcore-patched/XIVLauncher.Core" "$XLM_DIR/XIVLauncher.Core"
    echo "Installed to $XLM_DIR"
else
    echo "XLM directory not found. Binary at ~/xlcore-patched/XIVLauncher.Core"
fi
