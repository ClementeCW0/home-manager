{ config, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  networking.hostName = "desktop";
  services.getty.autologinUser = "clemente";
  services.flatpak.packages = [
  "com.audiorelay.AudioRelay" # Use phone as audio output
  ];
}
