{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  # Home Manager configuration with custom desktop entries
  home-manager = {
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

        chromium-private-desktop = pkgs.makeDesktopItem {
          name = "chromium";
          desktopName = "Chromium (Private)";
          exec = "chromium --disable-features=GlobalShortcutsPortal --profile-directory=Private %U";
          type = "Application";
          icon = "chromium";
          categories = [
            "Network"
            "WebBrowser"
          ];
        };

        chromium-redpill-linpro-desktop = pkgs.makeDesktopItem {
          name = "chromium-redpill-linpro";
          desktopName = "Chromium (Redpill-Linpro)";
          exec = "chromium --disable-features=GlobalShortcutsPortal --profile-directory=Redpill-Linpro %U";
          type = "Application";
          icon = ./redpill-linpro-favicon.png;
          categories = [
            "Network"
            "WebBrowser"
          ];
        };

        chromium-ascendis-desktop = pkgs.makeDesktopItem {
          name = "chromium-ascendis";
          desktopName = "Chromium (Ascendis)";
          exec = "chromium --disable-features=GlobalShortcutsPortal --profile-directory=Ascendis %U";
          type = "Application";
          icon = ./ascendis-favicon.png;
          categories = [
            "Network"
            "WebBrowser"
          ];
        };
      in
      {
        # Install custom desktop launchers for multiple work profiles
        home.packages = [
          teams-ascendis-desktop
          teams-redpill-linpro-desktop
          chromium-private-desktop
          chromium-redpill-linpro-desktop
          chromium-ascendis-desktop
        ];

        # Configuration files for Teams profiles and autostart
        home.file = {
          ".config/teams-for-linux/Redpill-Linpro/config.json".text = ''
            {
                "appTitle": "Teams-Redpill-Linpro",
                "appIcon": "/home/morten/.config/teams-for-linux/Redpill-Linpro/favicon.png",
                "minimized": "true",
                "electronCLIFlags": [
                  ["ozone-platform-hint","wayland"],
                  ["enable-features","WaylandWindowDecorations"]
                ],
                "cacheManagement": {
                  "enabled": false
                }
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
                ],
                "cacheManagement": {
                  "enabled": false
                }
            }
          '';

          ".config/teams-for-linux/Ascendis/favicon.png".source = ./ascendis-favicon.png;

          ".config/autostart/teams-ascendis.desktop".text = teams-ascendis-desktop.text;

          ".config/autostart/teams-redpill-linpro.desktop".text = teams-redpill-linpro-desktop.text;
        };
        home.stateVersion = "25.05";
      };
  };

  # Import additional modules
  imports = [
    ./agenix.nix
    ./tailscale.nix
  ];

  # Fingerprint reader support
  services.fprintd.enable = true;

  # Development and work packages
  environment.systemPackages = with pkgs; [
    annotator
    azurite
    bind
    claude-code
    dbeaver-bin
    dotnet-ef
    drawio
    filezilla
    gzip
    hugo
    jetbrains.rider
    jq
    junction
    nodejs
    postgresql
    postman
    sshfs
    unzip
    wget
    wireguard-tools
    zip
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

  # Enable /usr/bin/bash symlink for shell scripts expecting standard path
  services.envfs = {
    enable = true;
    extraFallbackPathCommands = ''
      ln -s ${pkgs.bash}/bin/bash $out/bash
    '';
  };

  # Dynamic linker for unpatched binaries (e.g., VS Code remote)
  programs.nix-ld.enable = true;

  # WireGuard VPN for Redpill-Linpro
  # Usage: systemctl start wg-quick-rp0.service
  networking.wg-quick.interfaces = {
    rp0 = {
      address = [
        "100.87.0.190/32"
        "2a02:c0:4f0:b01::be/128"
      ];
      dns = [
        "87.238.33.1"
        "2a02:c0::1"
      ];
      privateKeyFile = config.age.secrets.wg-private-key.path;
      autostart = false;
      peers = [
        {
          publicKey = "cJTr1DOHpz2L8y9zTkgpYyEaV6zDSrLhEBpY5q3tYQw=";
          presharedKeyFile = config.age.secrets.wg-preshared-key.path;
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "vpn.redpill-linpro.com:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # .NET globalization settings for compatibility
  environment.sessionVariables = {
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
  };

  # Force Chromium to start without profile picker
  programs.chromium = {
    extraOpts = {
      "ProfilePickerOnStartupAvailability" = 2;
    };
  };

  networking.hostName = "X1";

  # Drop request to http://169.254.169.254/metadata/identity/oauth2/token
  # See https://github.com/Azure/azure-sdk-for-net/issues/39532

  networking.firewall = {
    enable = true;
    extraCommands = ''
      iptables -A OUTPUT -d 169.254.169.254 -j DROP
    '';
  };

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
