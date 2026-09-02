#!/usr/bin/env bash
# ==============================================================================
# Cross-Platform Dotfiles Bootstrap Script (CachyOS / Arch / Termux / Generic)
# ==============================================================================
set -euo pipefail

GITHUB_REPO="erikenz/dotfiles" # Change this if your repo name differs

echo "=================================================="
echo "🚀 Initializing Dotfiles Bootstrap"
echo "=================================================="

# 1. Detect Environment
IS_TERMUX=false
IS_ARCH=false
IS_DEBIAN=false
IS_DARWIN=false

if [ -n "${TERMUX_VERSION:-}" ] || [ -d "/data/data/com.termux" ]; then
    IS_TERMUX=true
    echo "📱 Environment: Termux (Android)"
elif [ "$(uname -s)" = "Darwin" ]; then
    IS_DARWIN=true
    echo "🍎 Environment: macOS"
elif [ -f "/etc/os-release" ]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    if [[ "${ID:-}" =~ ^(cachyos|arch|endeavouros|manjaro)$ ]] || [[ "${ID_LIKE:-}" =~ arch ]]; then
        IS_ARCH=true
        echo "🐧 Environment: Arch Linux / CachyOS (${NAME:-Arch})"
    else
        IS_DEBIAN=true
        echo "🐧 Environment: Linux (${NAME:-Generic})"
    fi
fi

# 2. Install Git and Chezmoi prerequisites
echo "📦 Ensuring prerequisites (git, chezmoi, curl) are installed..."

if $IS_TERMUX; then
    pkg update -y
    pkg install -y git curl chezmoi || {
        # Fallback if chezmoi is not in repo yet
        sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b "$PREFIX/bin"
    }
elif $IS_ARCH; then
    sudo pacman -S --needed --noconfirm git curl chezmoi
elif $IS_DARWIN; then
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install chezmoi git
else
    # Generic Linux
    if ! command -v chezmoi &>/dev/null; then
        sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b "${HOME}/.local/bin"
        export PATH="${HOME}/.local/bin:${PATH}"
    fi
fi

# 3. Verify chezmoi installation
if ! command -v chezmoi &>/dev/null; then
    echo "❌ Error: chezmoi installation failed. Please install chezmoi manually and retry."
    exit 1
fi

echo " Chezmoi version: $(chezmoi --version)"

# 4. Initialize and apply dotfiles
echo "🔄 Applying dotfiles from GitHub..."
if [ -d "$HOME/.local/share/chezmoi/.git" ]; then
    echo "Chezmoi local repository found. Updating and applying..."
    chezmoi apply -v
else
    echo "Cloning and applying repository: $GITHUB_REPO..."
    chezmoi init --apply --verbose "$GITHUB_REPO"
fi

echo "=================================================="
echo "✨ Dotfiles setup completed successfully!"
echo "=================================================="
