{ config, pkgs, lib, ... }:
let
  homePathExists = builtins.pathExists /home/morten;
in
{
  age.identityPaths = [ "/home/morten/.ssh/id_rsa" ];

  environment.systemPackages = [ pkgs.ragenix ];

  systemd.tmpfiles.rules = lib.optionals homePathExists [
    "d /home/morten/repos 0755 morten users -"
    "d /home/morten/repos/Borum 0755 morten users -"
    "d /home/morten/repos/Borum/mobilepay 0755 morten users -"
  ];

  age.secrets = {
    wg-preshared-key = {
      file = ./secrets/wg-preshared-key.age;
      owner = "morten";
      group = "users";
    };

    wg-private-key = {
      file = ./secrets/wg-private-key.age;
      owner = "morten";
      group = "users";
    };

    tailscale-auth-key = {
      file = ./secrets/tailscale-auth-key.age;
      owner = "morten";
      group = "users";
    };

    jellyfin-admin = {
      file = ./secrets/jellyfin-admin.age;
      owner = "morten";
      group = "users";
    };

    jellyfin-jellyfin = {
      file = ./secrets/jellyfin-jellyfin.age;
      owner = "morten";
      group = "users";
    };
  } // lib.optionalAttrs homePathExists {
    mobilepay-env-prod = {
      file = ./secrets/mobilepay-env-prod.age;
      owner = "morten";
      group = "users";
      path = "/home/morten/repos/Borum/mobilepay/.env-prod";
    };

    mobilepay-env-test = {
      file = ./secrets/mobilepay-env-test.age;
      owner = "morten";
      group = "users";
      path = "/home/morten/repos/Borum/mobilepay/.env-test";
    };
  };
}