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
rm ./hosts/thinkpad/hardware-configuration.nix
rm flake.lock

echo "Generating hardware configuration..."
nixos-generate-config --show-hardware-config > ./hosts/thinkpad/hardware-configuration.nix

echo "Updating flake.nix with user: $USERNAME and hostname: $HOSTNAME..."

# Заменим user и hostname в flake.nix (используем jq-like или sed, вот вариант на sed)
sed -i -E "s/user = \"[^\"]+\";/user = \"$USERNAME\";/" flake.nix

sed -i -E "s/hostname = \"[^\"]+\";/hostname = \"$HOSTNAME\";/" flake.nix || true
# В твоём flake.nix hostname объявлен в hosts, не глобально, лучше не менять его здесь. hostname лучше передавать через nixos-rebuild (см ниже).

echo "Done! Config updated with:"
echo "  User: $USERNAME"
echo "  Host: $HOSTNAME"
echo
echo "To apply changes, run:"
echo "  sudo nixos-rebuild switch --flake ~/nixos#thinkpad --argstr user $USERNAME --argstr hostname $HOSTNAME"

