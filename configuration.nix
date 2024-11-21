#{ lib, config, pkgs, inputs, pkgs-unstable, ... }:
{ lib, config, pkgs, inputs, ... }:

let
  session = "${pkgs.hyprland}/bin/Hyprland";
in

{
  imports =
    [ 
      ./hardware-configuration.nix
      #./nix-alien.nix
      #./virt.nix
      #./docker.nix
      #./distrobox.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos";

  services.flatpak.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${session}";
        user = "morten";
      };
    };
  };

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

  services.gnome.core-utilities.enable = false;

  programs.fish.enable = true;
  
  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  users.users.morten = {
    isNormalUser = true;
    description = "morten";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  #programs.xfconf.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.morten = { lib, inputs, pkgs, ... }: 
    let 
      teams-ascendis-desktop = pkgs.makeDesktopItem {
        name = "teams-ascendis";
        desktopName = "Teams Ascendis";
        exec = "teams-for-linux --customUserDir=/home/morten/.config/teams-for-linux/Ascendis/";
        type = "Application";
      };

      teams-redpill-linpro-desktop = pkgs.makeDesktopItem {
        name = "teams-redpill-linpro";
        desktopName = "Teams Redpill-Linpro";
        exec = "teams-for-linux --customUserDir=/home/morten/.config/teams-for-linux/Redpill-Linpro/";
        type = "Application";
      };
    in {
    home.packages = [ pkgs.polkit_gnome teams-ascendis-desktop teams-redpill-linpro-desktop ];
    
    xfconf = {
      enable = true;
      settings = {
        thunar = {
          default-view = "ThunarDetailsView";
          misc-date-style = "THUNAR_DATE_STYLE_SHORT";
          last-show-hidden = true;
        };
      };
    };

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
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
      };
      extensions = with pkgs.vscode-extensions; [
        piousdeer.adwaita-theme
        ms-dotnettools.csharp
        ms-dotnettools.csdevkit
        yzhang.markdown-all-in-one
        github.copilot
        bbenoist.nix
        ms-dotnettools.vscode-dotnet-runtime
        esbenp.prettier-vscode
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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

    dconf = {
      settings = {
        "org/gnome/desktop/interface" = {
          gtk-theme = "Adwaita-dark";
          color-scheme = "prefer-dark";
        };
      };
    };

    gtk = {
      enable = true;
      theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
      cursorTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = 14;
      };
      font = {
        name = "DejaVu Sans";
        size = 10;
      };
    };

    home.sessionPath = [
      "/home/morten/bin/az"
    ];

    home.file = {
      ".config/teams-for-linux/Redpill-Linpro/config.json".text = ''
      {
          "optInTeamsV2": "true",
          "appTitle": "Teams-Redpill-Linpro",
          "appIcon": "/home/morten/.config/teams-for-linux/Redpill-Linpro/favicon.png",
          "notificationMethod": "web",
          "minimized": "false",
          "electronCLIFlags": [
            ["ozone-platform-hint","wayland"],
            ["enable-features","WaylandWindowDecorations"]
          ]
      }
      '';
    };

    home.file = {
      ".config/teams-for-linux/Ascendis/config.json".text = ''
      {
          "optInTeamsV2": "true",
          "appTitle": "Teams-Ascendis",
          "appIcon": "/home/morten/.config/teams-for-linux/Ascendis/favicon.png",
          "notificationMethod": "web",
          "minimized": "false",
         	"electronCLIFlags": [
            ["ozone-platform-hint","wayland"],
            ["enable-features","WaylandWindowDecorations"]
          ]
      }
      '';
    };


    home.file = {
      ".config/wofi/powermenu-style.css".text = ''
        #input {
          margin-bottom: 10px;
          border-radius: 3px;
          border:none;
        }

        #outer-box {
          margin-top: -35px;
          margin-left: 3px;
          margin-right: 3px;
          margin-bottom: 3px;
          padding:5px;
        }

        #text {
          padding: 5px;
        }
      '';
    };

    home.file = {
      ".config/wofi/powermenu-config".text = ''
        hide_search=true
        hide_scroll=true
        show=dmenu
        lines=6
        width=300
        insensitive=true
        normal_window=true
      '';
    };

    home.file = {
      ".config/scripts/powermenu.sh".executable = true;
      ".config/scripts/powermenu.sh".text = ''
        #!/usr/bin/env bash

        entries="Shutdown Reboot Logout Suspend Lock"

        selected=$(printf '%s\n' $entries | wofi --conf=/home/morten/.config/wofi/powermenu-config --style=/home/morten/.config/wofi/powermenu-style.css | awk '{print tolower($1)}')

        case $selected in
          logout)
            hyprctl dispatch exit;;
          suspend)
            exec systemctl suspend;;
          reboot)
            exec systemctl reboot;;
          shutdown)
            exec systemctl poweroff -i;;
          lock)
            exec gtklock;;
        esac
      '';
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
              "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            };
          };
        };
      };
      # https://mozilla.github.io/policy-templates/
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        FirefoxHome  =  {
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

        /* ---- EXTENSIONS ---- */
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          #"*".installation_mode = "blocked";
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" =  {
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

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "privacy"
            "network"
	          "pulseaudio"
	          "battery"
	          "backlight"
	          "clock"
	          "tray"
     	    ];
          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon}  {capacity}%";
            format-charging = "  {capacity}%";
            format-plugged = "  {capacity}%";
            format-alt = "{icon}  {time}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          clock = {
            interval = 10;
            format = "{:%H:%M}";
            format-alt = "  {:%e %b %Y %H:%M}";
            tooltip-format = "{:%e %B %Y}";
          };
          network = {
            interval = 5;
            format-wifi = "   {essid} ({signalStrength}%)";
            format-ethernet = "   {ifname}: {ipaddr}/{cidr}";
            format-disconnected = "   Disconnected";
            tooltip-format = "{ifname}: {ipaddr}";
            on-click = "nmtui";
          };
          pulseaudio = {
            scroll-step = 1;
            format = "   {volume}%   {format_source}%";
            on-click = "pavucontrol";
            on-scroll-up = "pamixer -ui 2";
            on-scroll-down = "pamixer -ud 2";
          };
          tray = {
            icon-size = 18;
            spacing = 10;
          };
          backlight = {
            interval = 5;
            format = "{icon}  {percent}%";
            format-icons = [
              "󱩎"
              "󱩐"
              "󱩒"
              "󱩔"
              "󱩖"
            ];
            on-scroll-up = "brightnessctl -c backlight set 5%+";
            on-scroll-down = "brightnessctl -c backlight set 5%-";
          };
          privacy = {
            icon-spacing = 14;
            icon-size = 14;
            transition-duration = 0;
            modules = [
              {
                type = "screenshare";
                tooltip = false;
              }
            ];
          };
        };
      };
      style = ''
        * {
            border: none;
            border-radius: 0;
            font-family: "DejaVu Sans", "Font Awesome";
            font-size: 13px;
        }

        window {
            background: #303030;
        }

        #workspaces button {
            padding: 5px 10px;
        }

        #workspaces button.icon label {
            font-size: 10px;
        }

        #workspaces button.active {
            background: #5294E3;
        }

        #privacy-item {
            padding: 5px 10px;
            background: #5294E3;
        }

        #clock, #battery, #network, #pulseaudio, #backlight, #tray, #mode #privacy {
            padding: 0 15px;
            margin: 0 2px;
        }

        #battery.warning {
            background: #f53c3c;
        }
      '';
    };

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile "/home/morten/nixos/hyprland.conf";
      plugins = [
        pkgs.hyprlandPlugins.hyprscroller
      ];
    };

    programs.alacritty = {
      enable = true;
      settings = {
        terminal.shell.program = "${pkgs.fish}/bin/fish";
        font.size = 10;
      };
    };
       
    programs.wofi = {
      enable = true;
      settings = {
        hide_search=false;
        hide_scroll=true;
        show="drun";
        width=500;
        lines=7;
        allow_images=true;
        insensitive=true;
        image_size=15;
        display_generic=true;
        normal_window=true;
      };
      style =
        ''
        #input {
          margin-bottom: 10px;
          border-radius: 3px;
          border:none;
        }

        #outer-box {
          margin: 3px;
          padding:5px;
        }

        #text {
          padding: 5px;
        }
        '';
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

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    fontconfig = {
      antialias = true;
      hinting.enable = true;
      hinting.autohint = true;
    };
    packages = with pkgs; [
      nerdfonts
      font-awesome
      source-code-pro
    ];
  };  

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  security.pam.services.gtklock = {};
  security.pam.services.greetd.enableGnomeKeyring = true;

  environment.systemPackages = (with pkgs; [
    git-credential-manager
    polkit_gnome
    unzip
    wget
    zip
    wireguard-tools
    grim
    slurp
    wl-clipboard
    wayland
    xdg-utils
    mako   
    libnotify
    home-manager
    pavucontrol
    pamixer
    brightnessctl
    gtklock
    swappy
    mattermost-desktop
    postman
    gzip
    htop
    (with dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_8_0
    ])
    libsecret
    wireplumber
    dconf
    filezilla
    azurite
    google-chrome
    drawio
    jetbrains.rider
    teams-for-linux
    azure-functions-core-tools
    ((azure-cli
      .withExtensions [ 
        azure-cli.extensions.account 
        ])
      .override { withImmutableConfig = false; })
  ]);
  
  #++ (with pkgs-unstable; [
  #]);

  programs.hyprland.enable = true;

  services.dbus.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  swapDevices = [{
    device = "/swapfile";
    size = 12 * 1024;
  }];

  zramSwap.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;

  services.gnome.gnome-keyring.enable = true;

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

  # systemctl start --user polkit-gnome-authentication-agent-1 & 
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
      };
    };
  };

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
      address = [ "100.87.0.190/32" "2a02:c0:4f0:b01::be/128" ];
      dns = [ "87.238.33.1" "2a02:c0::1" ];
      privateKeyFile = "/etc/wireguard/privatekey";
      autostart = true;
      
      peers = [
        {
          publicKey = "cJTr1DOHpz2L8y9zTkgpYyEaV6zDSrLhEBpY5q3tYQw=";
          presharedKey = "yzCceXj1cFTHfd0g0WTrt1McrmDErPWCTmeUHFbXV8o=";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "vpn.redpill-linpro.com:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
