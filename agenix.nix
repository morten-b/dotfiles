{ config, pkgs, ... }:
{
  age.identityPaths = [ "/home/morten/.ssh/id_rsa" ];

  environment.systemPackages = [ pkgs.ragenix ];

  # systemd.tmpfiles.rules = [
  #   "d /home/morten/repos 0755 morten users -"
  #   "d /home/morten/repos/Borum 0755 morten users -"
  #   "d /home/morten/repos/Borum/mobilepay 0755 morten users -"
  # ];

  age.secrets.wg-preshared-key = {
    file = ./secrets/wg-preshared-key.age;
    owner = "morten";
    group = "users";
  };

  age.secrets.wg-private-key = {
    file = ./secrets/wg-private-key.age;
    owner = "morten";
    group = "users";
  };

  age.secrets.tailscale-auth-key = {
    file = ./secrets/tailscale-auth-key.age;
    owner = "morten";
    group = "users";
  };

  # age.secrets.mobilepay-env-prod = {
  #   file = ./secrets/mobilepay-env-prod.age;
  #   owner = "morten";
  #   group = "users";
  #   path = "/home/morten/repos/Borum/mobilepay/.env-prod";
  # };

  # age.secrets.mobilepay-env-test = {
  #   file = ./secrets/mobilepay-env-test.age;
  #   owner = "morten";
  #   group = "users";
  #   path = "/home/morten/repos/Borum/mobilepay/.env-test";
  # };

  age.secrets.jellyfin-admin = {
    file = ./secrets/jellyfin-admin.age;
    owner = "morten";
    group = "users";
  };

  age.secrets.jellyfin-jellyfin = {
    file = ./secrets/jellyfin-jellyfin.age;
    owner = "morten";
    group = "users";
  };
}