{ config, pkgs, ... }:
{
  # Install HandBrake and DVD support packages
  environment.systemPackages = with pkgs; [
    handbrake
    libdvdcss
    libdvdnav
    libdvdread
    makemkv
    libva-utils
  ];

  # Add morten to necessary groups for DVD drive and GPU access
  users.users.morten.extraGroups = [
    "cdrom"
    "video"
    "render"
  ];

  # Set up directories for DVD ripping workflow
  systemd.tmpfiles.rules = [
    "d /home/morten/handbrake-watch 0775 morten users -"
    "d /home/morten/handbrake-output 0775 morten users -"
    "d /home/morten/handbrake-config 0775 morten users -"
  ];

  # Hardware acceleration for Intel GPU (Quick Sync Video)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # VAAPI for newer Intel GPUs (Broadwell+)
      intel-vaapi-driver # Older Intel GPUs support
      libva-vdpau-driver
      libvdpau-va-gl
      vpl-gpu-rt
    ];
  };

  # Environment variables for hardware acceleration
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Use iHD for intel-media-driver
  };
}
