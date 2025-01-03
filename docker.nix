{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  virtualisation.docker.enable = true;

  users.users.morten.extraGroups = [ "docker" ];
}
