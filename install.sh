#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

if ! command -v nix &>/dev/null; then
  echo "[*] Nix not found, installing…"
  sh <(curl -L https://nixos.org/nix/install) --yes
  echo "[*] Nix installed. Open a new terminal, then re-run this script."
  exit 0
fi

echo "[*] Nix already installed"
echo "[*] Linking dotfiles"
"$ROOT_DIR/link.sh"

if [ -d "$ROOT_DIR/commands" ]; then
  echo "[*] Installing custom commands"
  "$ROOT_DIR/install_commands.sh"
fi

echo "[*] Done"
echo "[*] Enter the dev shell with: nix develop"
echo "[*] Or start Nushell explicitly with: nix develop -c nu"
