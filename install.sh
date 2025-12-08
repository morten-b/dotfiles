#!/usr/bin/env bash
set -euo pipefail

# Clone dotfiles
echo "Cloning dotfiles..."
cd /tmp
sudo rm -rf dotfiles
git clone --branch disko https://github.com/morten-b/dotfiles.git
cd dotfiles

# Run disko
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --yes-wipe-all-disks --mode destroy,format,mount disk-config-T490-ext4.nix

# Install NixOS
cd /tmp/dotfiles
sudo nixos-install --flake .#T490