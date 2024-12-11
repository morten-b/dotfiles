{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: 
{
  environment.systemPackages = with pkgs; [
    nodejs
  ];
}