# Quick Reference Card

## Essential Commands

### Building & Switching

```bash
# Test changes without activating
just test X1

# Apply changes permanently
just switch X1

# Build without activating
just build X1
```

### Maintenance

```bash
# Update all dependencies
just update

# Format all Nix files
just format

# Check for errors
just check

# Clean old generations
just clean-old
```

### Secrets

```bash
# Edit a secret
ragenix -e secrets/example.age

# Re-encrypt all secrets
ragenix -r
```

### Information

```bash
# List system generations
just generations

# Show what would change
just diff X1

# Show flake info
just info
```

## File Locations

| What | Where |
|------|-------|
| System config | `configuration.nix` |
| X1 config | `configuration-X1.nix` |
| T490 config | `configuration-T490.nix` |
| User packages | `configuration.nix` (home-manager section) |
| VS Code | `vscode.nix` |
| Browser | `chromium.nix`, `firefox.nix` |
| Secrets | `secrets/*.age` |

## Common Tasks

### Add a Package

**System-wide:**
```nix
# In configuration.nix or machine-specific file
environment.systemPackages = with pkgs; [
  new-package
];
```

**User-level:**
```nix
# In configuration.nix under home-manager
home.packages = with pkgs; [
  new-package
];
```

### Add a Secret

```bash
# Create and edit
ragenix -e secrets/new-secret.age

# Configure in agenix.nix
age.secrets.new-secret = {
  file = ./secrets/new-secret.age;
  owner = "morten";
  group = "users";
};
```

### Rollback

```bash
# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Or reboot and select previous generation from boot menu
```

### Update Input

```bash
# Update nixpkgs only
just update-input nixpkgs

# Update home-manager only
just update-input home-manager
```

## Keyboard Shortcuts

| Combination | Action |
|-------------|--------|
| GNOME | Native GNOME shortcuts apply |
| Fish Shell | Standard fish completions |

## Network Services

| Service | Command | Port |
|---------|---------|------|
| Tailscale | `tailscale status` | - |
| WireGuard | `wg start/stop/status` | - |
| SSH | `systemctl status sshd` | 22 (T490) |

## Emergency

### System Won't Boot
1. Reboot
2. Select previous generation from boot menu
3. Debug from working system

### Lost SSH Key
- Cannot decrypt secrets without private key
- Restore from backup or re-encrypt all secrets

### Disk Full
```bash
# Clean old generations
sudo nix-collect-garbage -d

# Check disk usage
df -h
du -sh /nix/store
```

## Tips

- **Test before switch**: Always test major changes first
- **Commit often**: Small commits are easier to debug
- **Format code**: Run `just format` before committing
- **Read errors**: Nix errors are verbose but informative
- **Use search**: Search nixpkgs at search.nixos.org
- **Check wiki**: NixOS wiki has solutions to common issues

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Package Search](https://search.nixos.org/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [NixOS Wiki](https://nixos.wiki/)
