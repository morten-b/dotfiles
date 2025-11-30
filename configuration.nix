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
    ./agenix.nix
    ./tailscale.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

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
      "video"
    ];
    openssh.authorizedKeys.keyFiles = [
      ./id_rsa.pub
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
            last-selected-power-profile = "performance";
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
            delay = 500;
            repeat = true;
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
          "re/sonny/Junction" = {
            show-app-names = true;
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
        settings = {
          user = {
            name = "Morten Skov Bendtsen";
            email = "mosb@ascendispharma.com";
          };
          fetch = {
            prune = true;
          };
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    home-manager
    nixfmt-rfc-style
    wireplumber
    chromium
    docker-compose
    wl-clipboard
    github-copilot-cli
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.liveRestore = false;

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
  services.fwupd.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
}
