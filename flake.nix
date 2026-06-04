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
	};

	outputs = {self, nixpkgs, home-manager, zen-browser, ... } @ inputs: {
		nixosConfigurations.nixos-wacquez = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./configuration.nix
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
