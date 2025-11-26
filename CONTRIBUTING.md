# Contributing Guide

This document provides guidelines for maintaining and extending this NixOS configuration.

## Making Changes

### 1. Testing Changes

Always test changes before permanently applying them:

```bash
# Test without activation
sudo nixos-rebuild test --flake .#X1

# Or use just
just test X1
```

### 2. Formatting Code

Format Nix files before committing:

```bash
# Format all files
nixfmt *.nix

# Or use just
just format
```

### 3. Validation

Validate your changes with flake checks:

```bash
nix flake check

# Or use just
just check
```

### 4. Committing

Use descriptive commit messages:

```bash
git add .
git commit -m "feat: add new package for development"
git commit -m "fix: correct tailscale autoconnect timing"
git commit -m "docs: update README with new instructions"
```

## Adding New Packages

### System-Wide Packages

Add to `environment.systemPackages` in the appropriate configuration file:

- `configuration.nix` - Shared across all machines
- `configuration-X1.nix` - X1-specific packages
- `configuration-T490.nix` - T490-specific packages

```nix
environment.systemPackages = with pkgs; [
  # ... existing packages
  new-package
];
```

### User Packages (Home Manager)

Add to home-manager configuration:

```nix
home-manager = {
  users.morten = {
    home.packages = [
      pkgs.new-package
    ];
  };
};
```

## Managing Secrets

Secrets are encrypted with agenix using your SSH key.

### Adding a New Secret

1. Create the encrypted file:
```bash
ragenix -e secrets/new-secret.age
```

2. Add the secret configuration in `agenix.nix`:
```nix
age.secrets.new-secret = {
  file = ./secrets/new-secret.age;
  owner = "morten";
  group = "users";
};
```

3. Reference the secret in your configuration:
```nix
secretValue = config.age.secrets.new-secret.path;
```

### Editing Existing Secrets

```bash
ragenix -e secrets/existing-secret.age
```

### Re-encrypting All Secrets

After changing SSH keys:

```bash
ragenix -r
```

## Adding a New Machine

1. Generate hardware configuration:
```bash
nixos-generate-config --show-hardware-config > hardware-configuration-MACHINE.nix
```

2. Create machine-specific configuration:
```bash
cp configuration-T490.nix configuration-MACHINE.nix
# Edit as needed
```

3. Add the machine to `flake.nix`:
```nix
machines = [
  "T490"
  "X1"
  "MACHINE"  # Add here
];
```

4. Build and test:
```bash
just test MACHINE
```

## Updating Dependencies

### Update All Inputs

```bash
nix flake update
# Or
just update
```

### Update Specific Input

```bash
nix flake lock --update-input nixpkgs
# Or
just update-input nixpkgs
```

### Update VS Code Extensions

1. Find the extension on VS Code marketplace
2. Get the new version number
3. Update in `vscode.nix`:
```nix
{
  name = "extension-name";
  publisher = "publisher-name";
  version = "1.2.3";  # Update this
  sha256 = lib.fakeSha256;  # Use fake hash first
}
```
4. Build to get the real hash from error message
5. Replace `lib.fakeSha256` with the correct hash

## Troubleshooting

### Build Failures

1. Check syntax:
```bash
nix flake check
```

2. Try building without switching:
```bash
just build X1
```

3. Review error messages for missing dependencies or syntax errors

### Rollback to Previous Generation

```bash
# List generations
just generations

# Boot into previous generation
sudo nixos-rebuild switch --rollback
```

### Clear Build Cache

```bash
# Remove result symlinks
rm result*

# Clean old generations
just clean-old
```

## Best Practices

1. **Test before switching**: Always use `test` or `build` before `switch`
2. **Keep it modular**: Extract common patterns into separate `.nix` files
3. **Document complex configs**: Add comments explaining non-obvious configurations
4. **Pin versions carefully**: Balance stability with getting security updates
5. **Backup secrets**: Keep encrypted secrets in version control, but backup SSH keys separately
6. **Regular updates**: Update flake inputs regularly to get security patches
7. **Clean old generations**: Regularly clean up old system generations to save disk space

## Code Style

- Use 2 spaces for indentation
- Group related settings together with comments
- Keep lines under 120 characters when practical
- Use meaningful variable names in let bindings
- Format code with `nixfmt` before committing

## Getting Help

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [NixOS Wiki](https://nixos.wiki/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/)
- [NixOS Discourse](https://discourse.nixos.org/)
