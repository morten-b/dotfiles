# Clone dotfiles
cd /tmp
git clone --branch disko https://github.com/morten-b/dotfiles.git
cd dotfiles

# Create swap on /dev/sda3
sudo mkswap /dev/sda3
sudo swapon /dev/sda3

# Run disko
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount disk-config-T490.nix --yes-wipe-all-disks

# Install NixOS
sudo nixos-install --flake .#T490

# Fix home directory ownership (nixos-install creates it as root)
sudo chown -R morten:users /mnt/home/morten