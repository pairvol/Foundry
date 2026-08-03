#!/usr/bin/env bash
# Installs Foundry on Ubuntu / Ubuntu Cinnamon. Safe to re-run later to
# pull updates and reinstall.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/pairvol/Foundry/main/install-foundry.sh | bash
# or, from an existing checkout:
#   ./install-foundry.sh
set -euo pipefail

REPO_URL="https://github.com/pairvol/Foundry.git"
REPO_DIR="${FOUNDRY_REPO_DIR:-$HOME/Foundry}"
BIN_DIR="$HOME/.local/bin"

echo "Installing dependencies (GTK4, gjs, git)..."
sudo apt update
sudo apt install -y gjs gir1.2-gtk-4.0 git

if [ -d "$REPO_DIR/.git" ]; then
  echo "Updating existing checkout at $REPO_DIR..."
  git -C "$REPO_DIR" pull --ff-only
else
  echo "Cloning $REPO_URL to $REPO_DIR..."
  git clone "$REPO_URL" "$REPO_DIR"
fi

echo "Installing Foundry..."
make -C "$REPO_DIR" install

if ! grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi
export PATH="$BIN_DIR:$PATH"

echo "Installed. Run: foundry"
echo "(If this ran via 'curl | bash', open a new shell or run 'source ~/.bashrc' first --"
echo " PATH changes made in this script's process can't reach the shell that invoked it.)"
