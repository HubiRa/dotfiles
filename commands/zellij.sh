#!/bin/sh
set -eu

find_real_zellij() {
  self="$(command -v zellij 2>/dev/null || true)"
  which -a zellij 2>/dev/null | awk -v self="$self" '$0 != self { print; exit }'
}

if [ -n "${IN_NIX_SHELL-}" ] || [ "${DOTFILES_IN_NIX_ZELLIJ-}" = "1" ]; then
  real_zellij="$(find_real_zellij)"

  if [ -z "$real_zellij" ]; then
    echo "zellij wrapper: could not find the real zellij binary in PATH" >&2
    exit 1
  fi

  exec "$real_zellij" "$@"
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "zellij wrapper: nix is required to enter the dotfiles dev shell" >&2
  exit 1
fi

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
REPO_DIR="$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)"

exec env DOTFILES_IN_NIX_ZELLIJ=1 nix develop "$REPO_DIR" -c zellij "$@"
