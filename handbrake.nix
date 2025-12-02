{ config, pkgs, ... }:
{
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

  environment.systemPackages = with pkgs; [
    handbrake
    libdvdcss
    libdvdnav
    libdvdread
    libva-utils
  ];

  users.users.morten.extraGroups = [
    "cdrom"
    "video"
    "render"
  ];

  systemd.tmpfiles.rules = [
    "d /home/morten/Videos 0775 morten users -"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
}
