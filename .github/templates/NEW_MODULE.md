# New Module Template

Use this template when creating a new configuration module.

```nix
# Description of what this module does
{ config, pkgs, lib, ... }:

{
  # Configuration options
  
  # Example: Enable a service
  # services.myservice.enable = true;
  
  # Example: Install packages
  # environment.systemPackages = with pkgs; [
  #   package1
  #   package2
  # ];
  
  # Example: Configure options
  # services.myservice = {
  #   enable = true;
  #   option1 = "value1";
  #   option2 = true;
  # };
}
```

## Steps to Add a New Module

1. Create the new module file:
   ```bash
   touch my-module.nix
   ```

2. Add your configuration (use template above)

3. Import it in the appropriate configuration:
   ```nix
   # In configuration.nix or machine-specific file
   imports = [
     ./my-module.nix
   ];
   ```

4. Test the configuration:
   ```bash
   just test X1
   ```

5. Format and commit:
   ```bash
   just format
   git add my-module.nix configuration.nix
   git commit -m "feat: add my-module configuration"
   ```

## Examples

See existing modules for reference:
- `chromium.nix` - Browser configuration
- `tailscale.nix` - VPN service with auto-connect
- `agenix.nix` - Secret management
- `shairport.nix` - AirPlay receiver service
