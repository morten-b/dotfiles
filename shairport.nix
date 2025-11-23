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

  # packages
  environment = {
    systemPackages = with pkgs; [
      alsa-utils
      nqptp
      shairport-sync-airplay2
    ];
  };

  networking.networkmanager.wifi.powersave = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.userServices = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ 3689 5353 5000 7000 ];
    allowedUDPPorts = [ 5353 ];
    allowedTCPPortRanges = [
      { from = 32768; to = 60999; }
    ];
    allowedUDPPortRanges = [
      { from = 319; to = 320; }
      { from = 6000; to = 6009; }
      { from = 32768; to = 60999; }
    ];
  };

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
    shairport-sync = {
      description = "NAD speakers shairport-sync instance";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "avahi-daemon.service" "pipewire.service" ];
      serviceConfig = {
        User = "morten";
        Group = "users";
        Environment = [
          "XDG_RUNTIME_DIR=/run/user/1000"
        ];
        ExecStart = "${pkgs.shairport-sync-airplay2}/bin/shairport-sync -c /etc/NAD.conf";
        Restart = "on-failure";
        RestartSec = "5s";
        RuntimeDirectory = "shairport-sync";
      };
    };
  };

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