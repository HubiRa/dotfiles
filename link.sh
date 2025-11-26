#!/usr/bin/env bash
#
# Quick dotfiles linking script
# This script only handles the symlink part without reinstalling packages

set -euo pipefail

echo "Linking dotfiles using stow..."
stow nvim -t ~
stow helix -t ~
stow zellij -t ~
stow fish -t ~
stow yazi -t ~
stow nushell -t ~
# stow cursor -t ~
stow starship -t ~

echo "Dotfiles linked successfully!"
