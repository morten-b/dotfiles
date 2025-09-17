{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    hugo
    nodejs
    dotnet-sdk
    dbeaver-bin
    dotnet-ef
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      3000
      3001
    ];
  };
}
