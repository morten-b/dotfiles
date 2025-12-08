# Clone dotfiles
cd /tmp
git clone https://github.com/morten-b/dotfiles.git
cd dotfiles

# Create swap on /dev/sda3
sudo mkswap /dev/sda3
sudo swapon /dev/sda3

# Run disko
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount disk-config-.nix --yes-wipe-all-disks

# Install NixOS
sudo nixos-install --flake .#

# Fix home directory ownership (nixos-install creates it as root)
sudo chown -R 1000:100 /mnt/home/morten