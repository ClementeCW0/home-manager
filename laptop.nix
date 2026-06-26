{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  networking.hostName = "laptop";
  # Use tailscale to forward audio and keyboard/mouse input
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 
    4713    # PipeWire Audio
    24800   # Input Leap Keyboard/Mouse
  ];
  #networking.firewall.allowedTCPPorts = [ 24800 ];
}
