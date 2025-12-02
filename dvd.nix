{ config, pkgs, ... }:
{
  # Enable Intel QSV support in HandBrake
  nixpkgs.overlays = [
    (self: super: {
      handbrake = super.handbrake.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
          super.libvpl
        ];
        
        buildInputs = (old.buildInputs or []) ++ [
          super.libvpl
          super.libva
          super.libdrm
        ];
        
        configureFlags = (old.configureFlags or []) ++ [
          "--enable-qsv"
        ];
        
        NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -I${super.libvpl}/include/vpl";
        NIX_LDFLAGS = (old.NIX_LDFLAGS or []) ++ [ "-lva" "-lvpl" "-lva-drm" ];
      });
    })
  ];

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
      intel-media-driver # VAAPI driver for Intel QSV
      vpl-gpu-rt # oneVPL runtime for Intel QSV
    ];
  };

  # Environment variables for hardware acceleration
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Use iHD for intel-media-driver
  };
}
