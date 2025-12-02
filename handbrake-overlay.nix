self: super: {
  handbrake = super.handbrake.overrideAttrs (old: {
    # Enable Intel QSV by adding libvpl, libva, and libdrm
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
      super.libvpl
    ];
    
    buildInputs = (old.buildInputs or []) ++ [
      super.libvpl
      super.libva
      super.libdrm
    ];
    
    # Add --enable-qsv to configure flags
    configureFlags = (old.configureFlags or []) ++ [
      "--enable-qsv"
    ];
    
    # Add VPL include path so mfxvideo.h can be found
    NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -I${super.libvpl}/include/vpl";
    
    # Add libva and libvpl to linker flags
    NIX_LDFLAGS = (old.NIX_LDFLAGS or []) ++ [ "-lva" "-lvpl" "-lva-drm" ];
  });
}