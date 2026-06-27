{ 
	description = "Nixos Wacquez";
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-26.05";
		home-manager = {
			url = "github:nix-community/home-manager/release-26.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		zen-browser = {
			url = "github:0xc000022070/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nix-flatpak.url = "github:gmodena/nix-flatpak";
	};

	outputs = {self, nixpkgs, home-manager, zen-browser, nix-flatpak, ... } @ inputs: {
		nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./desktop.nix
				nix-flatpak.nixosModules.nix-flatpak
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.clemente = import ./home.nix;
						backupFileExtension = "bak";
						extraSpecialArgs = { inherit inputs; system = "x86_64-linux";};

					};
				}
			];
		};

		nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./laptop.nix
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.clemente = import ./home.nix;
						backupFileExtension = "bak";
						extraSpecialArgs = { inherit inputs; system = "x86_64-linux";};

					};
				}
			];
		};
	};
}
