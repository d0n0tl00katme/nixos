#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/d0n0tl00katme/nixos.git"
TARGET_DIR="$HOME/nixos"

USERNAME="$(whoami)"
HOSTNAME="$(hostname)"

echo "Cloning NixOS config from $REPO_URL to $TARGET_DIR..."
git clone "$REPO_URL" "$TARGET_DIR"
cd "$TARGET_DIR"
rm -rf .git

echo "Generating hardware configuration..."
nixos-generate-config --show-hardware-config > hardware-configuration.nix

echo "Replacing user and hostname in configuration.nix..."

sed -i -E "s/users\.users\.[a-zA-Z0-9_-]+ = \{/users.users.${USERNAME} = \{/" configuration.nix

sed -i -E "s/hostName = \".*\";/hostName = \"${HOSTNAME}\";/" configuration.nix

echo "Done! Config updated with:"
echo "  User: $USERNAME"
echo "  Host: $HOSTNAME"
echo "To apply changes, run:"
echo "  sudo nixos-rebuild switch --flake ~/nixos"
