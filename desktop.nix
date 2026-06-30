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
  musicDirectory = "/home/clemente/Music";
  user = "clemente"; 
  network.listenAddress = "any"; 
  
  settings = {
    audio_output = [
      {
        type = "pipewire";
        name = "Desktop Audio Server";
      }
      { # Visualizers
        type = "fifo";
        name = "my_fifo";
        path = "/run/user/1000/mpd.fifo";
        format = "44100:16:2";
      }

    ];
  };
};

systemd.services.mpd.environment = {
  XDG_RUNTIME_DIR = "/run/user/1000"; # Double-check your id -u just in case
};
################################################################################################


  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 
  	# 59100 # Audiorelay
	65530 # audio share
	6600  # MPD
  ];
}
