{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  networking.hostName = "desktop";
  services.getty.autologinUser = "clemente";

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



########## Sunshine ############################################################################
services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
  boot.kernelParams = [ 
    "video=DVI-D-1:1280x720@60D"  # Virtual display
    "video=HDMI-A-1:1920x1080@60" # Phisycal display
  ];
  # This option lets me see a mouse in the dummy display
  services.xserver.deviceSection = ''
  Option "SWcursor" "on"
'';
  # And this allows me to create the dummy display to the right of my phisycal display
  services.xserver.displayManager.setupCommands = ''
  ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-A-1 --mode 1920x1080 --primary --output DVI-D-1 --mode 1280x720 --right-of HDMI-A-1
'';
################################################################################################


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
      # 59100 # Audiorelay for closed source fans 
      # 65530 # audio share for open source enyjoyers   
      # 6600  # MPD
      4533    # Navidrome
      3131    # Deskreen
    ];
  };
};

#  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 
#  	# 59100 # Audiorelay for closed source fans 
#	65530 # audio share for open source enyjoyers   
#	6600  # MPD
#  ];
################################################################################################

}
