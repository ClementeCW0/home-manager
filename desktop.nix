{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  networking.hostName = "desktop";
  services.getty.autologinUser = "clemente";

  services.teamviewer.enable = true;


  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 
  	59100 # Audiorelay
  ];
}
