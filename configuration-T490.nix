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
    bash
    docker-compose  
    (
      with dotnetCorePackages;
      combinePackages [
        sdk_8_0
      ]
    )
  ];

  services.envfs = {
    enable = true;
    extraFallbackPathCommands = ''
      ln -s ${pkgs.bash}/bin/bash $out/bash
    '';
  };

  users.users.morten.extraGroups = [ "docker" ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      3000
      3001
    ];
  };
}
