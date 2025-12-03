{ config, pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # Use jellyfin-ffmpeg which has hardware acceleration support
  environment.systemPackages = with pkgs; [
    jellyfin-ffmpeg
  ];

  users.users.jellyfin.extraGroups = [ "video" "render" "users" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  systemd.tmpfiles.rules = [
    "d /home/morten 0751 morten users -"
    "d /home/morten/Videos 0775 morten users -"
  ];
}