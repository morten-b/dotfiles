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
      pkgs = import nixpkgs { inherit system; };
      machines = [
        "T14s"
        "T490"
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
              nixpkgs.config.allowUnfree = true;
            }
          ];
        };
      };
    in
    {
      nixosConfigurations = builtins.listToAttrs (map mkConfig machines);
    };
}
