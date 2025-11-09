#!/usr/bin/bash

set -e

mkdir -p "$HOME/.config"
stow -v --target "$HOME" nvim
stow -v --target "$HOME" helix
stow -v --target "$HOME" starship
stow -v --target "$HOME" zellij
stow -v --target "$HOME" yazi
stow -v --target "$HOME" fish
