{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  networking.hostName = "desktop";
  services.getty.autologinUser = "clemente";

  services.teamviewer.enable = true;

}
