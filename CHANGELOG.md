# Changelog

All notable changes to this NixOS configuration will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added
- Comprehensive README.md with setup instructions and feature overview
- CONTRIBUTING.md with maintenance guidelines
- SECURITY.md documenting security considerations and practices
- Justfile with 15+ common operations for easier management
- GitHub Actions CI workflow for automated validation
- Development shell with nixfmt, ragenix, and just
- .editorconfig for consistent code formatting across editors
- .gitattributes for proper handling of binary and text files
- Enhanced .gitignore with Nix-specific patterns
- Flake checks for automated configuration validation
- Formatter output to enable `nix fmt`

### Changed
- Improved repo-clone.sh with better error handling and documentation
- Added extensive inline comments to configuration files
- Made repo-clone.sh executable

### Documented
- Insecure package exception for dotnet-sdk-6.0.428
- Firewall rules and their purposes
- Secret management workflow with agenix
- Development workflow and best practices

## Template for Future Entries

### Added
- New features or capabilities

### Changed
- Changes to existing functionality

### Deprecated
- Features that will be removed in future versions

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security-related changes or fixes

---

## Version History Guidelines

When making significant changes, update this changelog:

1. Add your changes under "Unreleased" section
2. Use semantic versioning concepts (even though this is a personal config)
3. Group changes by category (Added, Changed, Fixed, etc.)
4. Be concise but descriptive
5. Include machine-specific changes if relevant

Example entry:
```markdown
## [2024-01-15] - Machine X1

### Added
- JetBrains Rider to development tools
- Custom Chromium profile for client work

### Fixed
- Azure IMDS endpoint blocking rule
```
