{
  config,
  pkgs,
  lib,
  ...
}:

{
  # user and group
  users = {
    users.shairport = {
      description = "Shairport user";
      isSystemUser = true;
      createHome = true;
      home = "/var/lib/shairport-sync";
      group = "shairport";
      extraGroups = [ "pulse-access" ];
    };
    groups.shairport = { };
  };

  # open firewall ports
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      3689
      5353
      5000
    ];
    allowedUDPPorts = [
      5353
    ];
    allowedTCPPortRanges = [
      {
        from = 7000;
        to = 7001;
      }
      {
        from = 32768;
        to = 60999;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 319;
        to = 320;
      }
      {
        from = 6000;
        to = 6009;
      }
      {
        from = 32768;
        to = 60999;
      }
    ];
  };

  # packages
  environment = {
    systemPackages = with pkgs; [
      alsa-utils
      nqptp
      shairport-sync-airplay2
    ];
  };

  # enable pulseaudio
  services.pipewire.enable = false;
  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
      systemWide = true;
    };
  };

  # enable Avahi
  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.userServices = true;
    #allowInterfaces = [ "enp2s0" ];
  };

  # systemd services
  systemd.services = {
    nqptp = {
      description = "Network Precision Time Protocol for Shairport Sync";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.nqptp}/bin/nqptp";
        Restart = "always";
        RestartSec = "5s";
      };
    };
    dining-room = {
      description = "NAD speakers shairport-sync instance";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
        "avahi-daemon.service"
      ];
      serviceConfig = {
        User = "shairport";
        Group = "shairport";
        ExecStart = "${pkgs.shairport-sync-airplay2}/bin/shairport-sync -c /etc/NAD.conf";
        Restart = "on-failure";
        RuntimeDirectory = "shairport-sync";
      };
    };
  };

  # write shairport-sync configs
  environment.etc."NAD.conf".text = ''
    general =
    {
      name = "NAD";
      output_backend = "pa";
      port = 7000;
      airplay_device_id_offset = 0;
    };
  '';
}

# run `sudo -u pulse PULSE_RUNTIME_PATH=/run/pulse pactl list sinks short` to display available sinks
# run `sudo -u pulse alsamixer` to adjust volume levels
# run `sudo alsactl store` so save the volume levels persistently
