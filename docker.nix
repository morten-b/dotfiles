{config, pkgs, ... }:

{
  users.users.morten.extraGroups = [ "docker" ];

  virtualisation.docker.enable = true;
}