{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  home-manager.users.morten = {
    home.file = {
      ".config/autostart/mattermost.desktop".text =
        builtins.readFile "${pkgs.mattermost-desktop}/share/applications/Mattermost.desktop";
    };
  };

  environment.systemPackages = with pkgs; [
    mattermost-desktop
  ];
}