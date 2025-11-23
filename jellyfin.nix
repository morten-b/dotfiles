{ config, pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users.users.jellyfin.extraGroups = [ "video" "users" ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiVdpau
    ];
  };

  systemd.tmpfiles.rules = [
    "d /home/morten 0751 morten users -"
    "d /home/morten/Media 0775 morten users -"
    "d /home/morten/Media/Movies 0775 morten users -"
  ];
}