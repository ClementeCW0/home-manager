{ config, lib, pkgs, ... }:
{
  options.mySystem.bootDevice = lib.mkOption {
    type = lib.types.str;
    default = "/dev/sda";
    description = "The disk device to install GRUB to.";
  };

  config = {
    boot.loader.grub.enable = true;
    boot.loader.grub.device = config.mySystem.bootDevice;
  };
}
