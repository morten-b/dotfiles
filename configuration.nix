{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./chromium.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

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

  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.fish.enable = true;

  # Setting up the fish shell as the default shell https://nixos.wiki/wiki/Fish
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  users.users.morten = {
    isNormalUser = true;
    description = "morten";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.morten = {
      imports = [
        ./vscode.nix
      ];

      # dconf dump / > old-conf.txt
      # dconf dump / > new-conf.txt
      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            enable-hot-corners = false;
          };
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = [
              pkgs.gnomeExtensions.appindicator.extensionUuid
            ];
          };
          "org/gnome/desktop/peripherals/mouse" = {
            speed = -0.7;
          };
          "org/gnome/desktop/wm/preferences" = {
            num-workspaces = 1;
          };
          "org/gnome/desktop/peripherals/keyboard" = {
            numlock-state = true;
          };
          "org/gnome/nautilus/preferences" = {
            default-folder-viewer = "list-view";
          };
          "org/gnome/desktop/sound" = {
            event-sounds = false;
          };
          "org/gnome/desktop/background" = {
            picture-options = "none";
            primary-color = "#164c54";
            color-shading-type = "solid";
          };
          "org/gnome/control-center" = {
            last-panel = "system";
          };
          "org/gnome/mutter" = {
            dynamic-workspaces = false;
          };
          "org/gnome/settings-daemon/plugins/power" = {
            sleep-inactive-ac-type = "nothing";
            sleep-inactive-battery-type = "nothing";
            idle-dim = false;
          };
          "org/gnome/desktop/session" = {
            idle-delay = lib.gvariant.mkUint32 0;
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

      home.stateVersion = "24.05";
    };
  };

  environment.systemPackages = with pkgs; [
    annotator
    bind
    docker-compose
    git-credential-manager
    gnomeExtensions.appindicator
    gzip
    home-manager
    nixfmt-rfc-style
    postman
    quickemu
    unzip
    wget
    wireguard-tools
    wireplumber
    zip
    unstable.jetbrains.rider
    junction
    bitwarden-desktop
    chromium
  ];

  environment.gnome.excludePackages = with pkgs; [
    orca
    baobab
    epiphany
    gnome-text-editor
    gnome-calendar
    gnome-characters
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

  # Should be available in NixOS 25.11
  # services.gnome.gcr-ssh-agent.enable = false;
  # programs.ssh.startAgent = false;

  environment.sessionVariables = {
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
    SSH_AUTH_SOCK = "/home/morten/.bitwarden-ssh-agent.sock";
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.liveRestore = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

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
