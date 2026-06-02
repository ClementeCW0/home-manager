{config, pkgs, ...}:

let
	dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in

{
	home.username = "clemente";
	home.homeDirectory = "/home/clemente";
	programs.git.enable = true;
	home.stateVersion = "26.05";
	programs.fish = {
		enable = true;
	};

	xdg.configFile."i3" = {
		source = create_symlink "${dotfiles}/i3/";
		recursive = true;
	};

	home.packages = with pkgs; [
    		neovim
		tmux
		nodejs
		gcc
	]


}
