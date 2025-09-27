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
    wireplumber.extraConfig."97-disable-devices" = {
      "monitor.alsa.rules" = [
        # Disable internal microphones
        {
          matches = [
            { "node.name" = "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source"; }
          ];
          actions.update-props = {
            "device.disabled" = true;
            "node.disabled" = true;
            "node.hidden" = true;
          };
        }
        {
          matches = [
            { "node.name" = "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic2__source"; }
          ];
          actions.update-props = {
            "device.disabled" = true;
            "node.disabled" = true;
            "node.hidden" = true;
          };
        }

        # Disable unwanted USB input
        {
          matches = [ { "node.name" = "alsa_input.usb-Generic_USB_Audio-00.iec958-stereo"; } ];
          actions.update-props = {
            "device.disabled" = true;
            "node.disabled" = true;
            "node.hidden" = true;
          };
        }

        # Disable HDMI sinks
        {
          matches = [
            { "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI1__sink"; }
          ];
          actions.update-props = {
            "device.disabled" = true;
            "node.disabled" = true;
            "node.hidden" = true;
          };
        }
        {
          matches = [
            { "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI2__sink"; }
          ];
          actions.update-props = {
            "device.disabled" = true;
            "node.disabled" = true;
            "node.hidden" = true;
          };
        }
        {
          matches = [
            { "node.name" = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__HDMI3__sink"; }
          ];
          actions.update-props = {
            "device.disabled" = true;
            "node.disabled" = true;
            "node.hidden" = true;
          };
        }

        # Disable speaker monitor (output loopback as input)
        {
          matches = [
            {
              "node.name" =
                "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink.monitor";
            }
          ];
          actions.update-props = {
            "device.disabled" = true;
            "node.disabled" = true;
            "node.hidden" = true;
          };
        }
      ];
    };
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
    };
  };

  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    home-manager
    nixfmt-rfc-style
    wireplumber
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
  services.fwupd.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
}
