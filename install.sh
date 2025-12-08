#!/usr/bin/env bash
set -euo pipefail

# Clone dotfiles
echo "Cloning dotfiles..."
cd /tmp
sudo rm -rf dotfiles
git clone --branch disko https://github.com/morten-b/dotfiles.git
cd dotfiles

# Create swap file on /dev/sda3
echo ""
echo "Setting up swap on /dev/sda3..."
sudo mkdir -p /mnt/swap
sudo fallocate -l 4G /mnt/swap/swapfile
sudo chmod 600 /mnt/swap/swapfile
sudo mkswap /mnt/swap/swapfile
sudo swapon /mnt/swap/swapfile
echo "Swap enabled (4GB on /dev/sda3)"

# Run disko
echo ""
echo "WARNING: This will destroy all data on /dev/nvme0n1"
read -p "Press Enter to continue or Ctrl+C to abort..."
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount disk-config-T490-ext4.nix

# Install NixOS
cd /tmp/dotfiles
sudo nixos-install --flake .#T490