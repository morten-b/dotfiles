{ pkgs ? import <nixpkgs> {}}:
let
  azureFunctions = pkgs.callPackage ./azure-functions-cli-bin.nix {};
  icu = pkgs.icu;
in
azureFunctions
