#!/usr/bin/env bash

set -euo pipefail

"$(cd "$(dirname "$0")" && pwd)/link.sh"

if [ -d "$(cd "$(dirname "$0")" && pwd)/commands" ]; then
  "$(cd "$(dirname "$0")" && pwd)/install_commands.sh"
fi
