{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      machines = [
        "T14s"
        "T490"
      ];
      overlays = [
        (final: prev: {
          chromium = prev.chromium.overrideAttrs (_: {
            postInstall = ''
              echo "Removing chromium-browser.desktop"
              rm -f $out/share/applications/chromium-browser.desktop
            '';
          });
        })
        (final: prev: {
          gnome-keyring = prev.gnome-keyring.overrideAttrs (oldAttrs: {
            mesonFlags = (builtins.filter (flag: flag != "-Dssh-agent=true") oldAttrs.mesonFlags) ++ [
              "-Dssh-agent=true"
            ];
          });
        })

      ];
      mkConfig = machine: {
        name = machine;
        value = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs self;
          };
          modules = [
            ./hardware-configuration-${machine}.nix
            ./configuration-${machine}.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config.allowUnfree = true;
              nixpkgs.config.permittedInsecurePackages = [
                "dotnet-sdk-6.0.428"
              ];
            }
          ];
        };
      };
    in
    {
      nixosConfigurations = builtins.listToAttrs (map mkConfig machines);
    };
}
