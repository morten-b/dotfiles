{ config, pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    libva-utils
  ];

  users.users.jellyfin.extraGroups = [ "video" "users" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libva-vdpau-driver
    ];
  };

  systemd.tmpfiles.rules = [
    "d /home/morten 0751 morten users -"
    "d /home/morten/Videos 0775 morten users -"
  ];
}