{ config, pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users.users.jellyfin.extraGroups = [ "video" "morten" ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiVdpau
    ];
  };

  systemd.tmpfiles.rules = [
    "z /home/morten/T490/Media 0750 morten morten -"
  ];
}