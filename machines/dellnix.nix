{ config, pkgs, ... }:

{
  imports = [
    ../modules/EFI/efi.nix
    ../common.nix
  ];

  networking.hostName = "dellnix";

  boot.kernelParams = [
  # Disable Wi-Fi power saving to fix choppy audio with bluetooth devices
   "rtw88_core.disable_lps_deep=Y"
   ];

  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver # Provides the iHD driver for modern Intel GPUs
    ];
  };
  
  # Force the system to use the modern Intel driver for hardware acceleration
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  # Use tailscale to forward audio and keyboard/mouse input
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 
    #4713    # PipeWire Audio
    24800   # Input Leap Keyboard/Mouse
  ];
  #networking.firewall.allowedTCPPorts = [ 4713 ];
}
