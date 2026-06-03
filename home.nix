{config, pkgs, ...}:

let
	dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/Config";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
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
	programs.fish = {
		enable = true;
	};

	xdg.configFile."i3" = {
		source = create_symlink "${dotfiles}/i3/";
		recursive = true;
	};

	xdg.configFile."nvim" = {
		source = create_symlink "${dotfiles}/nvim/";
		recursive = true;
	};

	xdg.configFile."tmux" = {
		source = create_symlink "${dotfiles}/tmux/";
		recursive = true;
	};

	home.packages = with pkgs; [
		lazygit
		tree-sitter

		linuxKernel.packages.linux_7_0.virtualboxGuestAdditions # Remove if not in a virtual machine

		# Wallpaper:
		python313Packages.pywal16
		python313Packages.colorthief # color grabbing backend
		imagemagick
		feh

		# Screenshots
		flameshot
	];

	home.sessionVariables = {
		EDITOR = "nvim";
	};

	# TODO: write the contents of Xresources. It should have the line
	#	#inlcude "/home/clemente/.cacche/wal/colors.Xresources"
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
