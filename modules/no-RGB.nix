{ config, pkgs, ... }:

{
  # Ensure OpenRGB and its udev rules are enabled
  services.hardware.openrgb.enable = true;

  systemd.services.openrgb-shutdown = {
    description = "Turn off RGB lights at shutdown";
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      # Tells systemd to consider the service "active" after ExecStart finishes
      RemainAfterExit = true;
      
      # Do nothing on startup
      ExecStart = "${pkgs.coreutils}/bin/true";
      
      # Send the exact hex color (black/off) to all devices during shutdown
      ExecStop = "${pkgs.openrgb}/bin/openrgb --mode direct --color 000000";
    };
  };
}
