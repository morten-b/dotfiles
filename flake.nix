{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      nixpkgs-unstable,
      nixpkgs,
      self,
      agenix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      machines = [
        "T490"
        "X1"
      ];
      overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
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
            agenix.nixosModules.default
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
