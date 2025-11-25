{ config, pkgs, ... }:
{
  age.identityPaths = [ "/home/morten/.ssh/id_rsa" ];

  environment.systemPackages = [ pkgs.ragenix ];

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

  age.secrets.mobilepay-env-prod = {
    file = ./secrets/mobilepay-env-prod.age;
    owner = "morten";
    group = "users";
    path = "/home/morten/repos/.env-prod";
  };

  age.secrets.mobilepay-env-test = {
    file = ./secrets/mobilepay-env-test.age;
    owner = "morten";
    group = "users";
    path = "/home/morten/repos/.env-test";
  };
}
