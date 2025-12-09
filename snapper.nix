{ config, pkgs, ... }:
{
  services.snapper = {
    settings = {
      home = {
        SUBVOLUME = "/home/morten";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 4;
        TIMELINE_LIMIT_MONTHLY = 6;
        TIMELINE_LIMIT_YEARLY = 0;
        ALLOW_USERS = [ "morten" ];
      };
      videos = {
        SUBVOLUME = "/srv/videos";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_DAILY = 1;
        TIMELINE_LIMIT_WEEKLY = 1;
        TIMELINE_LIMIT_MONTHLY = 1;
        TIMELINE_LIMIT_YEARLY = 0;
        ALLOW_USERS = [ "morten" ];
      };
      data = {
        SUBVOLUME = "/srv/data";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_DAILY = 1;
        TIMELINE_LIMIT_WEEKLY = 1;
        TIMELINE_LIMIT_MONTHLY = 1;
        TIMELINE_LIMIT_YEARLY = 0;
        ALLOW_USERS = [ "morten" ];
      };
    };
  };
}