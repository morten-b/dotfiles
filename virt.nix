{config, pkgs, ... }:

{
  programs.dconf.enable = true;
  
  users.users.morten.extraGroups = [ "libvirtd" "kvm" ];
  
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice 
    spice-gtk
    spice-protocol
    #win-virtio
    #in-spice
  ];
  
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

    home-manager.users.morten = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}