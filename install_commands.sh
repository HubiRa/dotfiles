#!/usr/bin/env bash
set -euo pipefail

# Resolve bin path (relative to this script)
COMMANDS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/commands" && pwd)"

# Make everything in bin executable
echo "Making scripts in ${COMMANDS_DIR} executable..."
chmod +x "${COMMANDS_DIR}"/*

# Create symlinks without .sh extension for easier command access
echo ""
echo "Installing commands:"
for cmd in "${COMMANDS_DIR}"/*.sh; do
  if [ -f "$cmd" ]; then
    cmd_name="$(basename "$cmd" .sh)"
    symlink="${COMMANDS_DIR}/${cmd_name}"
    
    # Create symlink if it doesn't exist or points to wrong target
    if [ ! -L "$symlink" ] || [ "$(readlink "$symlink")" != "$(basename "$cmd")" ]; then
      ln -sf "$(basename "$cmd")" "$symlink"
    fi
    
    echo "  - $cmd_name"
  fi
done
echo ""

# Detect current shell (the parent process that invoked this script)
# Try to get the parent shell from the process tree
PARENT_PID=$PPID
PARENT_SHELL=$(ps -p "$PARENT_PID" -o comm= 2>/dev/null || echo "")

# If we got a shell name, use it; otherwise fall back to $SHELL
if [ -n "$PARENT_SHELL" ]; then
  CURRENT_SHELL="$(basename "$PARENT_SHELL")"
else
  CURRENT_SHELL="$(basename "$SHELL")"
fi

echo "Detected shell: ${CURRENT_SHELL}"

case "${CURRENT_SHELL}" in
  bash)
    RC_FILE="${HOME}/.bashrc"
    LINE="export PATH=\"${COMMANDS_DIR}:\$PATH\""
    
    if ! grep -qxF "${LINE}" "${RC_FILE}"; then
      echo "${LINE}" >>"${RC_FILE}"
      echo "Added ${COMMANDS_DIR} to PATH in ${RC_FILE}"
    else
      echo "PATH already includes ${COMMANDS_DIR}"
    fi
    echo ""
    echo "Done! To use the commands in this shell, run:"
    echo "  source ${RC_FILE}"
    ;;
    
  zsh)
    RC_FILE="${HOME}/.zshrc"
    LINE="export PATH=\"${COMMANDS_DIR}:\$PATH\""
    
    if ! grep -qxF "${LINE}" "${RC_FILE}"; then
      echo "${LINE}" >>"${RC_FILE}"
      echo "Added ${COMMANDS_DIR} to PATH in ${RC_FILE}"
    else
      echo "PATH already includes ${COMMANDS_DIR}"
    fi
    echo ""
    echo "Done! To use the commands in this shell, run:"
    echo "  source ${RC_FILE}"
    ;;
    
  fish)
    RC_FILE="${HOME}/.config/fish/config.fish"
    LINE="set -gx PATH ${COMMANDS_DIR} \$PATH"
    
    # Create config directory if it doesn't exist
    mkdir -p "$(dirname "${RC_FILE}")"
    
    if ! grep -qF "set -gx PATH ${COMMANDS_DIR}" "${RC_FILE}" 2>/dev/null; then
      echo "${LINE}" >>"${RC_FILE}"
      echo "Added ${COMMANDS_DIR} to PATH in ${RC_FILE}"
    else
      echo "PATH already includes ${COMMANDS_DIR}"
    fi
    echo ""
    echo "Done! To use the commands in this shell, run:"
    echo "  source ${RC_FILE}"
    ;;
    
  nu|nushell)
    RC_FILE="${HOME}/.config/nushell/env.nu"
    
    # Create config directory if it doesn't exist
    mkdir -p "$(dirname "${RC_FILE}")"
    
    # Check if PATH modification already exists
    if ! grep -qF "prepend \"${COMMANDS_DIR}\"" "${RC_FILE}" 2>/dev/null; then
      echo "\$env.PATH = (\$env.PATH | prepend \"${COMMANDS_DIR}\")" >>"${RC_FILE}"
      echo "Added ${COMMANDS_DIR} to PATH in ${RC_FILE}"
    else
      echo "PATH already includes ${COMMANDS_DIR}"
    fi
    echo ""
    echo "Done! To use the commands in this shell, run:"
    echo "  source ${RC_FILE}"
    ;;
    
  *)
    echo "Warning: Unsupported shell '${CURRENT_SHELL}'"
    echo "Please manually add the following to your shell's config file:"
    echo "  ${COMMANDS_DIR}"
    exit 1
    ;;
esac
