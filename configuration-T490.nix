{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{

  home-manager = {
    users.morten = {
      home.stateVersion = "24.05";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      3000
      3001
    ];
  };
}
