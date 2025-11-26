# Justfile for common NixOS operations
# Install just: nix-shell -p just

# List available recipes
default:
    @just --list

# Build the specified machine configuration (e.g., just build X1)
build machine:
    sudo nixos-rebuild build --flake .#{{machine}}

# Switch to the specified machine configuration (e.g., just switch X1)
switch machine:
    sudo nixos-rebuild switch --flake .#{{machine}}

# Test the specified machine configuration without activating (e.g., just test X1)
test machine:
    sudo nixos-rebuild test --flake .#{{machine}}

# Format all Nix files using nixfmt
format:
    nixfmt *.nix

# Check flake for errors
check:
    nix flake check

# Update all flake inputs
update:
    nix flake update

# Update a specific flake input (e.g., just update-input nixpkgs)
update-input input:
    nix flake lock --update-input {{input}}

# Show flake metadata
show:
    nix flake show

# Show flake info
info:
    nix flake metadata

# Clean up old generations (requires sudo)
clean-old:
    sudo nix-collect-garbage --delete-older-than 30d

# Clean up all old generations except current (requires sudo)
clean-all:
    sudo nix-collect-garbage -d

# List all system generations
generations:
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Edit an agenix secret (e.g., just edit-secret secrets/example.age)
edit-secret secret:
    ragenix -e {{secret}}

# Re-encrypt all agenix secrets
rekey-secrets:
    ragenix -r

# Check which packages would be installed for a machine
dry-run machine:
    sudo nixos-rebuild dry-run --flake .#{{machine}}

# Show the differences that would be applied
diff machine:
    sudo nixos-rebuild build --flake .#{{machine}} && \
    nix store diff-closures /run/current-system ./result
