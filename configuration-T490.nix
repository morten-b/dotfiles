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
    icu
    hugo
    nodejs
    jetbrains.rider
    docker-compose  
    (
      with dotnetCorePackages;
      combinePackages [
        sdk_8_0
      ]
    )
  ];

  users.users.morten.extraGroups = [ "docker" ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      3000
      3001
    ];
  };
}
