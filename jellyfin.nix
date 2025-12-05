{ config, pkgs, ... }:

{
  services.declarative-jellyfin = {
    enable = true;
    openFirewall = true;
    user = "morten";
    dataDir = "/home/morten/.local/share/jellyfin";
    cacheDir = "/home/morten/.cache/jellyfin";
    configDir = "/home/morten/.config/jellyfin";
    system = {
      UICulture = "da";
    };
    users = {
      admin = {
        mutable = false;
        permissions.isAdministrator = true;
        hashedPasswordFile = config.age.secrets.jellyfin-admin.path;
      };
      jellyfin = {
        mutable = false;
        hashedPasswordFile = config.age.secrets.jellyfin-jellyfin.path;
      };
    };
    libraries = {
      Movies = {
        enabled = true;
        contentType = "movies";
        pathInfos = [ "/home/morten/Videos" ];
      };
      Shows = {
        enabled = true;
        contentType = "tvshows";
        pathInfos = [ "/home/morten/Videos" ];
      };
    };
    encoding = {
      enableHardwareEncoding = true;
      hardwareAccelerationType = "vaapi";
      hardwareDecodingCodecs = [ 
        "h264"
        "hevc"
      ];
    };
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
