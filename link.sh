#!/usr/bin/env bash
#
# Quick dotfiles linking script
# This script only handles the symlink part without reinstalling packages

set -euo pipefail

PACKAGES=(
  nvim
  helix
  zellij
  fish
  nushell
  yazi
  starship
  wezterm
  jj
)

echo "Linking dotfiles using stow..."
mkdir -p "$HOME/.config"
failed=()
for pkg in "${PACKAGES[@]}"; do
  if stow -n -v --target "$HOME" "$pkg" >/dev/null 2>&1; then
    stow -v --target "$HOME" "$pkg"
  else
    echo "[!] Skipping $pkg due to stow conflict"
    failed+=("$pkg")
  fi
done

if [ ${#failed[@]} -gt 0 ]; then
  echo "Dotfiles linked with conflicts. Skipped: ${failed[*]}"
  exit 1
fi

echo "Dotfiles linked successfully!"
