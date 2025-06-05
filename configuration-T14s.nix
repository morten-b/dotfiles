{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.morten =
      {
        lib,
        inputs,
        pkgs,
        ...
      }:
      let
        teams-ascendis-desktop = pkgs.makeDesktopItem {
          name = "teams-ascendis";
          desktopName = "Teams Ascendis";
          exec = "teams-for-linux --user-data-dir=/home/morten/.config/teams-for-linux/Ascendis/";
          type = "Application";
          icon = ./ascendis-favicon.png;
        };

        teams-redpill-linpro-desktop = pkgs.makeDesktopItem {
          name = "teams-redpill-linpro";
          desktopName = "Teams Redpill-Linpro";
          exec = "teams-for-linux --user-data-dir=/home/morten/.config/teams-for-linux/Redpill-Linpro/";
          type = "Application";
          icon = ./redpill-linpro-favicon.png;
        };
      in
      {
        home.packages = [
          teams-ascendis-desktop
          teams-redpill-linpro-desktop
        ];

        home.file = {
          ".config/teams-for-linux/Redpill-Linpro/config.json".text = ''
            {
                "appTitle": "Teams-Redpill-Linpro",
                "appIcon": "/home/morten/.config/teams-for-linux/Redpill-Linpro/favicon.png",
                "minimized": "true",
                "electronCLIFlags": [
                  ["ozone-platform-hint","wayland"],
                  ["enable-features","WaylandWindowDecorations"]
                ]
            }
          '';

          ".config/teams-for-linux/Redpill-Linpro/favicon.png".source = ./redpill-linpro-favicon.png;

          ".config/teams-for-linux/Ascendis/config.json".text = ''
            {
                "appTitle": "Teams-Ascendis",
                "appIcon": "/home/morten/.config/teams-for-linux/Ascendis/favicon.png",
                "minimized": "true",
                "electronCLIFlags": [
                  ["ozone-platform-hint","wayland"],
                  ["enable-features","WaylandWindowDecorations"]
                ]
            }
          '';

          ".config/teams-for-linux/Ascendis/favicon.png".source = ./ascendis-favicon.png;

          ".config/autostart/teams-ascendis.desktop".text = teams-ascendis-desktop.text;

          ".config/autostart/teams-redpill-linpro.desktop".text = teams-redpill-linpro-desktop.text;

          ".config/autostart/mattermost.desktop".text =
            builtins.readFile "${pkgs.mattermost-desktop}/share/applications/Mattermost.desktop";
        };
      };
  };

  environment.systemPackages = with pkgs; [
    jq
    azurite
    drawio
    jetbrains.rider
    mattermost-desktop
    filezilla
    teams-for-linux
    (
      (azure-cli.withExtensions [
        azure-cli.extensions.account
      ]).override
      { withImmutableConfig = false; }
    )
    (
      with dotnetCorePackages;
      combinePackages [
        sdk_6_0
        sdk_8_0
      ]
    )
    (callPackage ./azure-functions-cli-bin.nix { })
  ];

  services.envfs = {
    enable = true;
    extraFallbackPathCommands = ''
      ln -s ${pkgs.bash}/bin/bash $out/bash
    '';
  };

  # Drop request to http://169.254.169.254/metadata/identity/oauth2/token
  # See https://github.com/Azure/azure-sdk-for-net/issues/39532
  networking.firewall = {
    enable = true;
    extraCommands = ''
      iptables -A OUTPUT -d 169.254.169.254 -j DROP
    '';
  };
}
