{ pkgs }:

pkgs.handbrake.overrideAttrs (oldAttrs: {
  buildInputs = oldAttrs.buildInputs ++ (with pkgs; [
    intel-media-driver
    vpl-gpu-rt
    libva
  ]);

  configureFlags = (oldAttrs.configureFlags or []) ++ [
    "--enable-qsv"
  ];
})
