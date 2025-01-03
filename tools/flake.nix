{
  description = "Flake for using package.nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";  # Adjust to your specific nixpkgs repo

  outputs = { self, nixpkgs }: let
    # Import nixpkgs
    pkgs = import nixpkgs { system = "x86_64-linux"; };  # Adjust to your system

  in {
    # Use the package directly
    packages.x86_64-linux.default = pkgs.callPackage ./package.nix {};

    # Optionally, create a devShell if you'd like to enter the environment
    devShell.x86_64-linux = pkgs.mkShell {
      buildInputs = [
        self.packages.x86_64-linux.default
      ];
    };
  };
}