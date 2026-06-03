{config, pkgs, ...}:

let
	dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/Config";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
	configs = {
		i3 = "i3";
		i3status = "i3status";
		nvim = "nvim";
		tmux = "tmux";
		picom = "picom";
	};

	myDmenu = pkgs.dmenu.overrideAttrs (old: {
		patches = (old.patches or []) ++ [
			./patches/dmenu/dmenu-center-20250407-b1e217b.diff
			];
		});
in

{
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

	xdg.configFile = builtins.mapAttrs
		(name: subpath: {
			source = create_symlink "${dotfiles}/${subpath}";
			recursive = true;
			}) configs;

	home.packages = with pkgs; [
		lazygit
		tree-sitter

		linuxKernel.packages.linux_7_0.virtualboxGuestAdditions # Remove if not in a virtual machine

		# Wallpaper:
		python313Packages.pywal16
		python313Packages.colorthief # color grabbing backend
		imagemagick # color grabbing backend
		feh

		myDmenu

		# Screenshots
		flameshot
	];

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
