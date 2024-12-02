{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "nixos";

  services.flatpak.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Copenhagen";

  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  console.keyMap = "dk-latin1";

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.fish.enable = true;

  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  users.users.morten = {
    isNormalUser = true;
    description = "morten";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

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
          exec = "teams-for-linux --customUserDir=/home/morten/.config/teams-for-linux/Ascendis/";
          type = "Application";
          icon = ./ascendis-favicon.png;
        };

        teams-redpill-linpro-desktop = pkgs.makeDesktopItem {
          name = "teams-redpill-linpro";
          desktopName = "Teams Redpill-Linpro";
          exec = "teams-for-linux --customUserDir=/home/morten/.config/teams-for-linux/Redpill-Linpro/";
          type = "Application";
          icon = ./redpill-linpro-favicon.png;
        };
      in
      {
        home.packages = [
          teams-ascendis-desktop
          teams-redpill-linpro-desktop
        ];

        programs.vscode = {
          enable = true;
          mutableExtensionsDir = false;
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;
          package = pkgs.vscode.fhs;
          userSettings = {
            "workbench.colorTheme" = "Adwaita Dark & default syntax highlighting & colorful status bar";
            "workbench.startupEditor" = "none";
            "git.autofetch" = true;
            "git.confirmSync" = false;
            "security.workspace.trust.untrustedFiles" = "open";
            "editor.largeFileOptimizations" = false;
            "nix.formatterPath" = "nixfmt";
            "[json]" = {
              "editor.defaultFormatter" = "esbenp.prettier-vscode";
            };
          };
          extensions =
            with pkgs.vscode-extensions;
            [
              piousdeer.adwaita-theme
              ms-dotnettools.csharp
              ms-dotnettools.csdevkit
              yzhang.markdown-all-in-one
              github.copilot
              ms-dotnettools.vscode-dotnet-runtime
              esbenp.prettier-vscode
              jnoortheen.nix-ide
            ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "vscode-bicep";
                publisher = "ms-azuretools";
                version = "0.30.23";
                sha256 = "sha256-WkHPZdeo42aro0qoy9EY1IauPFw9+Ld7dxJQTK4XLuE=";
              }
              {
                name = "vscode-base64";
                publisher = "adamhartford";
                version = "0.1.0";
                sha256 = "sha256-ML3linlHH/GnsoxDHa0/6R7EEh27rjMp0PcNWDmB8Qw=";
              }
            ];
        };

        # dconf dump / > old-conf.txt
        # dconf dump / > new-conf.txt
        dconf = {
          enable = true;
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
            };
            "org/gnome/shell" = {
              disable-user-extensions = false;
              enabled-extensions = [
                pkgs.gnomeExtensions.appindicator.extensionUuid
              ];
            };
          };
        };

        home.file = {
          ".config/teams-for-linux/Redpill-Linpro/config.json".text = ''
            {
                "optInTeamsV2": "true",
                "appTitle": "Teams-Redpill-Linpro",
                "appIcon": "/home/morten/.config/teams-for-linux/Redpill-Linpro/favicon.png",
                "notificationMethod": "web",
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
                "optInTeamsV2": "true",
                "appTitle": "Teams-Ascendis",
                "appIcon": "/home/morten/.config/teams-for-linux/Ascendis/favicon.png",
                "notificationMethod": "web",
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

          ".config/autostart/mattermost.desktop".text = builtins.readFile "${pkgs.mattermost-desktop}/share/applications/Mattermost.desktop";
        };

        programs.firefox = {
          enable = true;
          profiles = {
            default = {
              id = 0;
              name = "default";
              isDefault = true;
              search = {
                force = true;
                default = "Google";
                order = [ "Google" ];
                engines = {
                  "Google".metaData.alias = "@g";
                };
              };
            };
          };
          # https://mozilla.github.io/policy-templates/
          policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            FirefoxHome = {
              Search = false;
              TopSites = false;
              SponsoredTopSites = false;
              Highlights = false;
              Pocket = false;
              SponsoredPocket = false;
              Snippets = false;
              Locked = true;
            };
            FirefoxSuggest = {
              WebSuggestions = false;
              SponsoredSuggestions = false;
              ImproveSuggest = false;
              Locked = false;
            };
            AutofillCreditCardEnabled = false;
            TranslateEnabled = false;
            PasswordManagerEnabled = false;
            OfferToSaveLogins = false;
            DisablePocket = true;
            DisableFirefoxAccounts = true;
            DisableAccounts = true;
            DisableFirefoxScreenshots = true;
            DisableSetDesktopBackground = true;
            OverrideFirstRunPage = "";
            OverridePostUpdatePage = "";
            DontCheckDefaultBrowser = true;
            DisplayBookmarksToolbar = "never";
            SearchBar = "unified";

            # Check about:support for extension/add-on ID strings.
            # Valid strings for installation_mode are "allowed", "blocked",
            # "force_installed" and "normal_installed".
            ExtensionSettings = {
              #"*".installation_mode = "blocked";
              "uBlock0@raymondhill.net" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                installation_mode = "force_installed";
              };
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                installation_mode = "force_installed";
              };
            };
          };
        };

        programs.fish = {
          enable = true;
          shellAliases = {
            myip = "curl https://am.i.mullvad.net/ip";
          };
          interactiveShellInit = ''
            set fish_greeting # Disable greeting
            set fish_color_autosuggestion A0A0A0
          '';
          functions = {
            wg = ''
              systemctl $argv wg-quick-rp0.service
            '';
          };
        };

        programs.alacritty = {
          enable = true;
          settings = {
            terminal.shell.program = "${pkgs.fish}/bin/fish";
            font.size = 10;
          };
        };

        programs.git = {
          enable = true;
          package = pkgs.gitFull;
          userName = "Morten Skov Bendtsen";
          userEmail = "mosb@ascendispharma.com";
          extraConfig = {
            fetch = {
              prune = true;
            };
          };
        };

        # The state version is required and should stay at the version you
        # originally installed.
        home.stateVersion = "24.05";
      };
  };

  environment.systemPackages = with pkgs; [
    annotator
    azure-functions-core-tools
    azurite
    drawio
    filezilla
    git-credential-manager
    gnomeExtensions.appindicator
    google-chrome
    gzip
    home-manager
    jetbrains.rider
    mattermost-desktop
    nixfmt-rfc-style
    postman
    quickemu
    teams-for-linux
    unzip
    wget
    wireguard-tools
    wireplumber
    zip
    (
      with dotnetCorePackages;
      combinePackages [
        sdk_6_0
        sdk_8_0
      ]
    )
    (
      (azure-cli.withExtensions [
        azure-cli.extensions.account
      ]).override
      { withImmutableConfig = false; }
    )
  ];

  # GNOME dynamic triple buffering
  # See https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1441
  nixpkgs.overlays = [
    (final: prev: {
      mutter = prev.mutter.overrideAttrs (oldAttrs: {
        src = final.fetchFromGitLab {
          domain = "gitlab.gnome.org";
          owner = "vanvugt";
          repo = "mutter";
          rev = "triple-buffering-v4-47";
          hash = "sha256-JaqJvbuIAFDKJ3y/8j/7hZ+/Eqru+Mm1d3EvjfmCcug=";
        };

        preConfigure =
          let
            gvdb = final.fetchFromGitLab {
              domain = "gitlab.gnome.org";
              owner = "GNOME";
              repo = "gvdb";
              rev = "2b42fc75f09dbe1cd1057580b5782b08f2dcb400";
              hash = "sha256-CIdEwRbtxWCwgTb5HYHrixXi+G+qeE1APRaUeka3NWk=";
            };
          in
          ''
            cp -a "${gvdb}" ./subprojects/gvdb
          '';
      });
    })
  ];

  environment.gnome.excludePackages = with pkgs; [
    orca
    baobab
    epiphany
    gnome-text-editor
    gnome-calendar
    gnome-characters
    gnome-console
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-system-monitor
    gnome-weather
    gnome-connections
    gnome-tour
    simple-scan
    snapshot
    totem
    yelp
    gnome-software
    geary
  ];

  services.dbus.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 12 * 1024;
    }
  ];

  zramSwap.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # Drop request to http://169.254.169.254/metadata/identity/oauth2/token
  # See https://github.com/Azure/azure-sdk-for-net/issues/39532
  networking.firewall = {
    enable = true;
    extraCommands = ''
      iptables -A OUTPUT -d 169.254.169.254 -j DROP
    '';
  };

  # systemctl start wg-quick-wg0.service
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
      privateKeyFile = "/etc/wireguard/privatekey";
      autostart = false;
      peers = [
        {
          publicKey = "cJTr1DOHpz2L8y9zTkgpYyEaV6zDSrLhEBpY5q3tYQw=";
          presharedKey = "yzCceXj1cFTHfd0g0WTrt1McrmDErPWCTmeUHFbXV8o=";
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
}
