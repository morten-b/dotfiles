{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  environment.systemPackages = [ pkgs.distrobox ];
}
