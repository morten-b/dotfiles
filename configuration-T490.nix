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

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      3000
      3001
    ];
  };
}
