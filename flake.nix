{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    #nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
#  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: 
  let 
    system = "x86_64-linux";
    commonArgs = { inherit system; config.allowUnfree = true; };
    pkgs = import nixpkgs commonArgs;
    #pkgs-unstable = import nixpkgs-unstable commonArgs;
   in {
    nixosConfigurations.morten = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs self pkgs;
#        inherit inputs self pkgs pkgs-unstable;
      };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
					home-manager.extraSpecialArgs = {inherit inputs ;};
				}
      ];
    };
  };
}