#!/bin/sh
set -eu

if ! command -v zoxide >/dev/null 2>&1; then
  echo "content: requires zoxide (https://github.com/ajeetdsouza/zoxide)" >&2
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "usage: content <fuzzy-pattern> [--nu] [eza flags...]" >&2
  exit 2
fi

pattern="$1"
shift

# Check for --nu flag
use_nu=false
if [ "${1:-}" = "--nu" ]; then
  use_nu=true
  shift
fi

dir="$(zoxide query -- "$pattern")"
echo "Content of: $dir"
echo ""

# Use nushell's ls if --nu flag is set and nushell is available
if [ "$use_nu" = true ] && command -v nu >/dev/null 2>&1; then
  exec nu -c "ls '$dir'"
else
  # Use eza by default
  exec eza "$@" -- "$dir"
fi
