{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      unstable,
    }@inputs:
    let
      system = "x86_64-linux";
      nixpkgsConfig = {
        allowUnfree = true;
        download-buffer-size = 524288000; # 500 MiB
      };
      pkgs = import nixpkgs {
        inherit system;
        config = nixpkgsConfig;
      };
      unstablePkgs = import unstable {
        inherit system;
        config = nixpkgsConfig;
      };
      machines = [
        "T14s"
        "T490"
      ];
      mkConfig = machine: {
        name = machine;
        value = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs self unstablePkgs;
          };
          modules = [
            ./hardware-configuration-${machine}.nix
            ./configuration-${machine}.nix
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
      };
    in
    {
      nixosConfigurations = builtins.listToAttrs (map mkConfig machines);
    };
}
