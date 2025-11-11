{ config, pkgs, ... }:
{
  age.identityPaths = [ "/home/morten/.ssh/id_rsa" ];
  
  environment.systemPackages = [ pkgs.agenix ];
}