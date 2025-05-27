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
nixos-generate-config --show-hardware-config > ./hosts/thinkpad/hardware-configuration.nix

echo "Updating flake.nix with user: $USERNAME and hostname: $HOSTNAME..."

sed -i -E "s/user = \"[^\"]+\";/user = \"$USERNAME\";/" flake.nix

sed -i -E "s/hostname = \"[^\"]+\";/hostname = \"$HOSTNAME\";/" flake.nix || true

echo "Done! Config updated with:"
echo "  User: $USERNAME"
echo "  Host: $HOSTNAME"
echo
echo "To apply changes, run:"
echo "  sudo nixos-rebuild switch --flake ~/nixos#thinkpad --argstr user $USERNAME --argstr hostname $HOSTNAME"

