{ config, pkgs, ... }:

{
  imports = [
    ../modules/BIOS/bios.nix
    ../common.nix
  ];

  # Set the custom option defined in bios.nix
  mySystem.bootDevice = "/dev/sda";

  networking.hostName = "senteynix";
  services.getty.autologinUser = "clemente";

########## Network #############################################################################
networking = {
  interfaces = {
    enp3s0 = {
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
