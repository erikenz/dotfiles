#!/usr/bin/env bash
set -euo pipefail

if ! grep -qi '^ID=arch' /etc/os-release 2>/dev/null; then
  exit 0
fi

if ! command -v paru &>/dev/null; then
  echo "[INFO] Installing paru..."
  sudo pacman -S --needed --noconfirm base-devel git
  tmpdir=$(mktemp -d)
  git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
  pushd "$tmpdir/paru" >/dev/null
  makepkg -si --noconfirm
  popd >/dev/null
  rm -rf "$tmpdir"
else
  echo "[INFO] paru is already installed."
fi
