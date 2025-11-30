# NixOS Dotfiles

Personal NixOS configuration managed with flakes and home-manager.

## 📚 Documentation

- **[Quick Reference](QUICKREF.md)** - Common commands and quick tips
- **[Architecture](ARCHITECTURE.md)** - System architecture and design
- **[Contributing Guide](CONTRIBUTING.md)** - How to maintain and extend
- **[Security Notes](SECURITY.md)** - Security considerations and practices
- **[Changelog](CHANGELOG.md)** - Track changes and updates

## 📋 Overview

This repository contains declarative NixOS configurations for multiple machines:
- **X1**: Primary workstation with full development setup
- **T490**: Secondary machine with Shairport Sync for audio streaming

## 🚀 Quick Start

### Prerequisites

- NixOS with flakes enabled
- SSH key at `/home/morten/.ssh/id_rsa` for agenix secrets

### Building a Configuration

```bash
# Build the X1 configuration
sudo nixos-rebuild switch --flake .#X1

# Build the T490 configuration
sudo nixos-rebuild switch --flake .#T490
```

### Testing Changes

```bash
# Check flake syntax
nix flake check

# Format Nix files
nixfmt *.nix
```

## 📁 Repository Structure

```
.
├── flake.nix                        # Main flake configuration
├── configuration.nix                # Shared system configuration
├── configuration-{X1,T490}.nix      # Machine-specific configurations
├── hardware-configuration-*.nix     # Hardware-specific settings
├── agenix.nix                       # Secret management with agenix
├── chromium.nix                     # Chromium browser policies
├── firefox.nix                      # Firefox browser policies
├── tailscale.nix                    # Tailscale VPN configuration
├── vscode.nix                       # VS Code with extensions
├── shairport.nix                    # AirPlay audio receiver (T490)
├── azure-functions-cli-bin.nix      # Custom package derivation
└── secrets/                         # Encrypted secrets (agenix)
```

## 🛠️ Key Features

### System Configuration
- **Desktop Environment**: GNOME with customized settings
- **Shell**: Fish (default) with Bash fallback
- **Package Management**: Nix flakes with nixpkgs-unstable overlay
- **Secrets Management**: agenix for encrypted secrets

### Development Tools
- .NET SDK (6.0, 8.0)
- Node.js
- Docker with Docker Compose
- Azure CLI with extensions
- PostgreSQL, DBeaver
- JetBrains Rider
- VS Code with Copilot and .NET extensions

### Applications
- Chromium with multiple profiles (Private, Redpill-Linpro, Ascendis)
- Teams for Linux (dual profile setup)
- Firefox with privacy-focused policies
- Git with configured credentials

### Security & Privacy
- DNS over HTTPS (NextDNS)
- Tailscale VPN
- WireGuard (Redpill-Linpro VPN)
- Chromium with blocked third-party tracking
- Firefox with enhanced tracking protection

## 🔒 Secrets Management

Secrets are managed using [agenix](https://github.com/ryantm/agenix) and stored in the `secrets/` directory.

### Managing Secrets

```bash
# Edit a secret
ragenix -e secrets/example.age

# Re-encrypt all secrets
ragenix -r
```

### Available Secrets
- `wg-private-key.age`: WireGuard private key
- `wg-preshared-key.age`: WireGuard preshared key
- `tailscale-auth-key.age`: Tailscale authentication key
- `mobilepay-env-*.age`: Environment files for specific projects

## 🎨 Customization

### GNOME Settings
GNOME desktop preferences are managed declaratively via dconf in `configuration.nix`. Key customizations:
- Dark mode enabled
- Hot corners disabled
- Single workspace
- No idle screen dimming
- Nautilus list view by default

### Browser Profiles
Multiple Chromium profiles are configured for different contexts:
- Private (personal use)
- Redpill-Linpro (work)
- Ascendis (client)

Each profile has its own desktop launcher with custom icons.

## 🔄 Updating

### Update Flake Inputs

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
```

### Update VS Code Extensions

VS Code extensions are pinned with SHA256 hashes. To update:
1. Find the new version and publisher from VS Code marketplace
2. Update version in `vscode.nix`
3. Update SHA256 hash (use `lib.fakeSha256` first, then replace with actual hash from error)

## 📝 Common Tasks

### Switch Fish Function for WireGuard

```bash
# Start VPN
wg start

# Stop VPN
wg stop

# Check status
wg status
```

### Check Tailscale Status

```bash
tailscale status
```

### Docker Operations

```bash
# User is in docker group, no sudo needed
docker ps
docker-compose up
```

## 🧪 Development Workflow

1. Make changes to `.nix` files
2. Test with `sudo nixos-rebuild test --flake .#<machine>`
3. Format with `nixfmt *.nix`
4. Commit changes
5. Apply permanently with `sudo nixos-rebuild switch --flake .#<machine>`

## 📦 Custom Packages

### azure-functions-cli-bin
Custom derivation for Azure Functions Core Tools, packaged as a binary with patched ELF dependencies.

## ⚠️ Notes

- **Insecure Package**: `dotnet-sdk-6.0.428` is permitted for legacy project compatibility
- **X1 Firewall**: Drops requests to Azure IMDS endpoint (169.254.169.254) to prevent SDK issues
- **T490**: Configured as AirPlay receiver, lid switch disabled for always-on operation

## 📄 License

This is a personal dotfiles repository. Feel free to use as inspiration, but note that configurations are tailored to specific hardware and use cases.

## 🤝 Contributing

This is a personal configuration repository, but suggestions and improvements are welcome via issues or pull requests.
