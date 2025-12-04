{ config, pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "morten";
    dataDir = "/home/morten/.local/share/jellyfin";
    cacheDir = "/home/morten/.cache/jellyfin";
    configDir = "/home/morten/.config/jellyfin";
  };

  environment.systemPackages = with pkgs; [
    libva-utils
    jellyfin-ffmpeg
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libva-vdpau-driver
    ];
  };
}