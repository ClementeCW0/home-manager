# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;



  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager = {
  enable = true;
  wifi.powersave = false;
  };
  networking.nftables.enable = true;

  hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  settings = {
    General = {
      # Shows battery charge of connected devices on supported
      # Bluetooth adapters. Defaults to 'false'.
      Experimental = true;
      # When enabled other devices can connect faster to us, however
      # the tradeoff is increased power consumption. Defaults to
      # 'false'.
      FastConnectable = false;
    };
    Policy = {
      # Enable all controllers when they are found. This includes
      # adapters present on start as well as adapters that are plugged
      # in later on. Defaults to 'true'.
      AutoEnable = true;
    };
  };
};

# Input emulation
hardware.uinput.enable = true;

  # Set your time zone.
  time.timeZone = "America/Santiago";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  #services.libinput-gestures.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.clemente = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "uinput" "video" "render" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  nixpkgs.config.allowUnfree = true;
  programs.steam.enable = true;
  programs.dconf.enable = true;
  programs.nix-ld.enable = true;

######################################################## VIDEO ACCELERATION #############################
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.graphics = { # hardware.opengl until NixOS 24.05
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD (for HD Graphics starting Broadwell (2014) and newer)
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver
##########################################################################################################
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim 
    neovim
    ranger
    tmux
    wget
    git
    git-crypt
    openssh
    alacritty
    gnumake
    networkmanagerapplet
    ripgrep-all

    #inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}

    xinit
    arandr
    xdotool
    pwvucontrol
    pulseaudio # I use pipewire, but I need pactl

    libinput
    libinput-gestures
    wmctrl

    brightnessctl
    picom
    jq
    killall
    playerctl


    nodejs

    # Compilers
    cargo
    gcc

  ];

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver = {
	enable = true;
	autoRepeatDelay = 200;
	autoRepeatInterval = 35;
	displayManager.startx.enable = true;
	windowManager.i3.enable = true;
  };


  # Greet with Nix logo
  environment.etc."issue".text = builtins.readFile ./nixlogo.txt;

  fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
      enable = true;
      openFirewall = true;
      ports = [ 
      	1729 
      ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "clemente" ];
        MaxAuthTries = 3;
        PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
	X11Forwarding = true;
      };
    };

  services.tailscale.enable = true;

  system.stateVersion = "26.05";

}
