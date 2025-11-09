#!/usr/bin/env bash
set -e

if ! command -v nix &>/dev/null; then
  echo "[*] Nix not found, installing…"
  sh <(curl -L https://nixos.org/nix/install) --yes
  echo "[*] Nix installed. Open a new terminal, then run: nix develop"
else
  echo "[*] Nix already installed. Just run: nix develop"
fi
