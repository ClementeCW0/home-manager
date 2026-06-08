{config, pkgs, system, inputs, ...}:

let
	dotfiles = "${config.home.homeDirectory}/home-manager/Config";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
	configs = {
		i3 = "i3";
		i3status = "i3status";
		nvim = "nvim";
		tmux = "tmux";
		picom = "picom";
		alacritty = "alacritty";
		libinput = "libinput-gestures.conf";
	};

	myDmenu = pkgs.dmenu.overrideAttrs (old: {
		patches = (old.patches or []) ++ [
			./patches/dmenu/dmenu-center-20250407-b1e217b.diff
			./patches/dmenu/dmenu-xresources-4.9.diff
			];
		});
in

{

	imports = [
			./modules/theme.nix
		];
	home.username = "clemente";
	home.homeDirectory = "/home/clemente";
	programs.git = {
		enable = true;
		settings = {
			user = {
				name = "Clemente Wacquez";
				email = "clemente.wacquez@uc.cl";
			};
		init.defaultBranch = "main";
		};
	};
	home.stateVersion = "26.05";
	programs.bash = {
		enable = true;
	};
	#programs.steam.enable = true;

	xdg.configFile = builtins.mapAttrs
		(name: subpath: {
			source = create_symlink "${dotfiles}/${subpath}";
			recursive = true;
			}) configs;

	home.packages = with pkgs; [
		lazygit
		tree-sitter

		# linuxKernel.packages.linux_7_0.virtualboxGuestAdditions # Remove if not in a virtual machine

		inputs.zen-browser.packages."${system}".default

		# Wallpaper:
		python313Packages.pywal16
		python313Packages.colorthief # color grabbing backend
		imagemagick # color grabbing backend
		feh

		myDmenu

		# Screenshots
		flameshot
		
		# Games, emulation
		steam
		wine64
		openmw

		# Flexing
		fastfetch
		htop
		cmatrix

		zathura
		texpresso
		texliveFull

	];
  	#services.picom.enable = true;

	home.sessionVariables = {
		EDITOR = "nvim";
		#PATH = builtins.getEnv "PATH" + "${config.home.homeDirectory}/.local/share/nvim/mason";
	};

	
	# Theme setup

	home.file.".Xresources".text = ''
	#include "/home/clemente/.cache/wal/colors.Xresources"
	'';

	home.file.".xinitrc".text = ''
	#!/bin/sh
	setxkbmap latam
	xrdb -merge ~/.Xresources

	xset s off
	xset -dpms
	xset s noblank

	exec i3
	'';
}
