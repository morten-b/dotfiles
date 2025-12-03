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
      intel-vaapi-driver # Legacy driver for better HEVC support on 8th gen
      vpl-gpu-rt
      libva
    ];
  };

  # Ensure VAAPI uses the right driver
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  systemd.tmpfiles.rules = [
    "d /home/morten 0751 morten users -"
    "d /home/morten/Videos 0775 morten users -"
  ];
}