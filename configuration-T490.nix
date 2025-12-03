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
  imports = [
    ./shairport.nix
    ./jellyfin.nix
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
