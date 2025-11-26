# Security Notes

## Permitted Insecure Packages

### dotnet-sdk-6.0.428

**Status**: Permitted insecure package

**Reason**: Required for legacy .NET 6 projects that cannot be immediately upgraded to .NET 8.

**Risk Assessment**: 
- This is a development environment, not a production server
- The package is only used for local development
- Network exposure is minimal and controlled

**Mitigation**:
- Projects should be migrated to .NET 8 when feasible
- Avoid running untrusted code with this SDK
- Keep other system packages up to date

**Configuration Location**: `flake.nix` - search for `permittedInsecurePackages`

```nix
nixpkgs.config.permittedInsecurePackages = [
  "dotnet-sdk-6.0.428"
];
```

**Action Items**:
- [ ] Audit .NET 6 projects for upgrade feasibility
- [ ] Plan migration to .NET 8 SDK
- [ ] Remove this exception once migration is complete

## Firewall Rules

### Azure IMDS Endpoint Block (X1)

**Configuration**: `configuration-X1.nix` - search for "Drop request to http://169.254.169.254"

Drops requests to `169.254.169.254` to prevent Azure SDK from attempting to access Instance Metadata Service locally.

**Reason**: See [Azure SDK Issue #39532](https://github.com/Azure/azure-sdk-for-net/issues/39532)

**Impact**: None for local development; prevents unnecessary network requests and warnings.

## Secret Management

Secrets are encrypted using [agenix](https://github.com/ryantm/agenix) with age encryption.

### Secret Storage

- Encrypted secrets are stored in `secrets/*.age`
- Encrypted with SSH public key at `id_rsa.pub`
- Decrypted at runtime using `~/.ssh/id_rsa`

### Secret Backup

**Important**: Backup your SSH private key separately. If lost, encrypted secrets cannot be recovered.

```bash
# Backup your SSH key (store securely, not in git)
cp ~/.ssh/id_rsa ~/backup/id_rsa.backup
```

### Secret Re-encryption

After rotating SSH keys:

```bash
# Update public key
cp ~/.ssh/id_rsa.pub ./id_rsa.pub

# Re-encrypt all secrets with new key
ragenix -r
```

## Security Best Practices

1. **Regular Updates**: Run `nix flake update` regularly to get security patches
2. **Review Logs**: Check system logs for suspicious activity
3. **Firewall**: Keep firewall enabled and review rules periodically
4. **SSH Keys**: Use strong SSH keys (Ed25519 recommended)
5. **Secret Rotation**: Rotate secrets periodically, especially shared secrets
6. **VPN**: Use Tailscale or WireGuard for secure remote access
7. **Browser Security**: DNS-over-HTTPS enabled for privacy
8. **Minimal Exposure**: Only open necessary ports on firewall

## Audit Log

| Date | Change | Reason |
|------|--------|--------|
| 2024 | Added dotnet-sdk-6.0.428 exception | Required for legacy projects |
| 2024 | Added Azure IMDS block | Prevent SDK metadata requests |

## Reporting Security Issues

For security concerns or vulnerabilities found in this configuration, please create a private issue or contact the repository owner directly.
