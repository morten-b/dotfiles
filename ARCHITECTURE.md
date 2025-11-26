# Architecture Overview

This document describes the architecture and organization of this NixOS configuration.

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         flake.nix                            │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Inputs: nixpkgs, home-manager, agenix               │   │
│  │ Outputs: nixosConfigurations, checks, formatter     │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                           │
                           ├─────────────┬─────────────┐
                           ▼             ▼             ▼
                    ┌─────────────┐ ┌─────────────┐   │
                    │     X1      │ │    T490     │   │
                    └─────────────┘ └─────────────┘   │
                           │             │            │
                           ▼             ▼            ▼
              ┌────────────────────────────────────────────┐
              │         configuration.nix                  │
              │  (shared configuration for all machines)   │
              │                                             │
              │  • Boot loader                              │
              │  • Networking                               │
              │  • Users                                    │
              │  • Desktop (GNOME)                          │
              │  • System packages                          │
              │  • Home Manager                             │
              └────────────────────────────────────────────┘
                           │
                           ├──────────┬──────────┬──────────┐
                           ▼          ▼          ▼          ▼
                   ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
                   │chromium  │ │ agenix   │ │tailscale │ │ vscode   │
                   │   .nix   │ │  .nix    │ │  .nix    │ │  .nix    │
                   └──────────┘ └──────────┘ └──────────┘ └──────────┘
```

## Module Structure

### Core Configuration

```
flake.nix                      # Flake definition and inputs
├── configuration.nix          # Shared system configuration
├── configuration-X1.nix       # X1-specific configuration
├── configuration-T490.nix     # T490-specific configuration
├── hardware-configuration-X1.nix      # X1 hardware detection
└── hardware-configuration-T490.nix    # T490 hardware detection
```

### Feature Modules

```
chromium.nix                   # Browser policies and settings
firefox.nix                    # Firefox policies (not currently imported)
tailscale.nix                  # VPN with auto-connect
agenix.nix                     # Secret management
vscode.nix                     # VS Code configuration and extensions
shairport.nix                  # AirPlay receiver (T490 only)
azure-functions-cli-bin.nix    # Custom package derivation
```

### Secrets

```
secrets/
├── wg-private-key.age         # WireGuard private key
├── wg-preshared-key.age       # WireGuard preshared key
├── tailscale-auth-key.age     # Tailscale authentication
├── mobilepay-env-prod.age     # Project-specific env file
└── mobilepay-env-test.age     # Project-specific env file
```

## Configuration Layers

### Layer 1: Hardware
- Detected hardware configuration
- File system mounts
- Boot loader settings

### Layer 2: System
- NixOS system configuration
- Services (SSH, Docker, etc.)
- Network configuration
- Firewall rules

### Layer 3: Desktop
- GNOME configuration via dconf
- Display manager (GDM)
- System packages

### Layer 4: User
- Home Manager configuration
- User packages
- Shell configuration (Fish)
- Git configuration
- Application settings

### Layer 5: Applications
- VS Code with extensions
- Browser configurations
- Custom desktop entries

## Data Flow

### Build Process

```
1. User runs: just switch X1
                │
                ▼
2. Nix evaluates flake.nix
                │
                ├─> Fetches inputs (nixpkgs, home-manager, agenix)
                ├─> Imports configuration-X1.nix
                ├─> Imports configuration.nix
                ├─> Imports hardware-configuration-X1.nix
                └─> Imports modules (chromium, tailscale, etc.)
                │
                ▼
3. Builds system closure
                │
                ├─> Evaluates all options
                ├─> Builds packages
                └─> Generates configuration files
                │
                ▼
4. Activates configuration
                │
                ├─> Switches systemd units
                ├─> Restarts changed services
                └─> Updates boot loader
```

### Secret Management

```
1. Encrypted secrets in git
                │
                ▼
2. agenix module reads secrets
                │
                ▼
3. Decrypts using SSH key at build time
                │
                ▼
4. Places decrypted files in /run/agenix/
                │
                ▼
5. Services reference decrypted paths
```

## Machine Profiles

### X1 (Primary Workstation)

**Purpose**: Development workstation for .NET and Azure work

**Key Features**:
- Full development stack (.NET, Node.js, Docker)
- Multiple Chromium profiles for different contexts
- Teams for Linux with dual profiles
- WireGuard VPN for corporate network
- Fingerprint authentication
- Azure Functions CLI

**Special Configuration**:
- Blocks Azure IMDS endpoint
- Profile picker disabled in Chromium
- Wayland support for Teams

### T490 (Secondary/Server)

**Purpose**: Headless AirPlay receiver

**Key Features**:
- Shairport Sync for AirPlay
- SSH server enabled
- Lid switch ignored (always-on)
- Minimal package set

**Special Configuration**:
- PipeWire for audio routing
- Avahi for mDNS/discovery
- Extensive firewall rules for AirPlay

## Dependency Graph

```
nixpkgs ────────────┐
                    │
nixpkgs-unstable ───┼──> flake.nix
                    │
home-manager ───────┤
                    │
agenix ─────────────┘
```

## Build Outputs

### Primary Outputs

- `nixosConfigurations.X1` - X1 system configuration
- `nixosConfigurations.T490` - T490 system configuration
- `formatter.x86_64-linux` - nixfmt-rfc-style
- `devShells.x86_64-linux.default` - Development environment

### Checks

- `checks.x86_64-linux.X1` - Validates X1 builds
- `checks.x86_64-linux.T490` - Validates T490 builds

## Extension Points

### Adding a New Machine

1. Generate hardware config
2. Create `configuration-MACHINE.nix`
3. Add to `machines` list in `flake.nix`

### Adding a Module

1. Create `module-name.nix`
2. Import in `configuration.nix` or machine-specific file
3. Configure options

### Adding a Secret

1. Create with `ragenix -e secrets/name.age`
2. Configure in `agenix.nix`
3. Reference in configuration

## Best Practices

1. **Modularity**: Keep related settings in dedicated modules
2. **Layering**: Use machine-specific files only for machine-specific settings
3. **Documentation**: Comment complex configurations
4. **Testing**: Always test before switching
5. **Atomicity**: Make small, focused changes
