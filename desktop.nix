{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  networking.hostName = "desktop";
  services.getty.autologinUser = "clemente";

  services.teamviewer.enable = true;

########## MPD #################################################################################
services.mpd = {
  enable = true;
  musicDirectory = "/home/clemente/Music"; # Updated to your user path
  user = "clemente"; 
  network.listenAddress = "any"; 
  
  settings = {
    # Notice the square brackets added here to make it a list
    audio_output = [
      {
        type = "pipewire";
        name = "Desktop Audio Server";
      }
    ];
  };
};

systemd.services.mpd.environment = {
  XDG_RUNTIME_DIR = "/run/user/1000"; # Double-check your id -u just in case
};
################################################################################################


  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 
  	59100 # Audiorelay
	6600  # MPD
  ];
}
