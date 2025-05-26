# My Nixos Setup

## Installation
```
git clone https://github.com/d0n0tl00katme/nixos.git ~/nixos 
cd ~/nixos
rm hardware-configuration.nix
nixos-generate-config --show-hardware-config > hardware-configuration.nix
sudo nixos-rebuild switch --flake ~/nixos#{YOUR_HOSTNAME}
```
