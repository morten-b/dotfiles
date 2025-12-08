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
      home.stateVersion = "25.11";
    };
  };
  imports = [
    ./shairport.nix
    ./jellyfin.nix
    ./disk-config-T490.nix
  ];

  programs.chromium = {
    extraOpts = {
      "ProfilePickerOnStartupAvailability" = 1;
    };
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };

  networking.hostName = "T490";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  system.stateVersion = "25.11";
}
