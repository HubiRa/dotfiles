#!/bin/bash

function maybe_install() {
  local cmd="$1"
  local pkg="$2"
  local method="$3"  # "cargo" or empty

  if ! hash "$cmd" > /dev/null 2>&1; then
    echo "Installing $cmd..."

    if [[ "$method" == "cargo" && -n "$(command -v cargo)" ]]; then
      cargo install "$pkg" --locked
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      brew install "$pkg"
    elif [[ -f /etc/debian_version ]]; then
      sudo apt-get update
      sudo apt-get install -y "$pkg"
    else
      echo "Warning: No supported install method for $cmd. Skipping."
    fi
  else
    echo "$cmd is already installed."
  fi
}


if [[ "$1" == "install" ]]; then
  if ! hash cargo > /dev/null 2>&1; then
    echo "Rust (cargo) not found. Installing via rustup..."
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    export PATH="$HOME/.cargo/bin:$PATH"
  fi

  maybe_install stow stow
  maybe_install neovim neovim # might install outdated version on ubuntu
  maybe_install helix helix cargo
  maybe_install zellij zellij cargo
  maybe_install yazi yazi cargo
  maybe_install fzf fzf cargo
  maybe_install rg ripgrep cargo
  maybe_install dust du-dust cargo
  maybe_install gh gh
  maybe_install lazygit lazygit # wont work under linux
  maybe_install gitui gitui # if lazygit can't be installed
fi



mkdir -p "$HOME/.config"
stow -v --target "$HOME" nvim
stow -v --target "$HOME" helix
stow -v --target "$HOME" starship
stow -v --target "$HOME" zellij
stow -v --target "$HOME" yazi
