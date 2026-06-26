{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  networking.hostName = "laptop";
  networking.firewall.allowedTCPPorts = [ 24800 ];
}
