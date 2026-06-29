{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  networking.hostName = "desktop";
  services.getty.autologinUser = "clemente";

  services.teamviewer.enable = true;
  services.mpd.enable = true; # Remote music hell yeah


  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 
  	59100 # Audiorelay
	6600  # MPD
  ];
}
