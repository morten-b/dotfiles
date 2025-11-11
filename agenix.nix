{ config, pkgs, ... }:
{
  age.identityPaths = [ "/home/morten/.ssh/id_rsa" ];

  environment.systemPackages = [ pkgs.ragenix ];

  # age.secrets.wg-preshared-key = {
  #   file = ./secrets/wg-preshared-key.age;
  #   owner = "morten";
  #   group = "users";
  # };
}
