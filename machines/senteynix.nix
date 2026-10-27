{ config, pkgs, ... }:

{
  imports = [
    ../modules/BIOS/bios.nix
    ../common.nix
  ];
  imports = [
  ];

  # Set the custom option defined in bios.nix
  mySystem.bootDevice = "/dev/sda";

  networking.hostName = "sentey";
  services.getty.autologinUser = "clemente";

########## Network #############################################################################
networking = {
  interfaces = {
    enp4s0 = {
      wakeOnLan.enable = true;
    };
  };
  firewall = {
    allowedUDPPorts = [ 9 ];
    interfaces."tailscale0".allowedTCPPorts = [ 
      4533    # Navidrome
    ];
  };
};

################################################################################################

}
