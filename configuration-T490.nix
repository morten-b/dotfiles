{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  home-manager = {
    users.morten =
      { config, ... }:
      {
        home = {
          file = {
            Videos.source = config.lib.file.mkOutOfStoreSymlink "/srv/videos";
            Data.source = config.lib.file.mkOutOfStoreSymlink "/srv/data";
          };
          stateVersion = "25.11";
        };
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

  systemd.tmpfiles.rules = [
    "d /srv/videos 0755 morten users -"
    "d /srv/data 0755 morten users -"
  ];

  system.stateVersion = "25.11";
}
