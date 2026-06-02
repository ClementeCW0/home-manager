let
	nixos-version = "26.05"
in

{ 
	description = "Nixos Wacquez";
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-${nixos-version}";
		home-manager = {
			url = "github:nix-community/home-manager/release-${nixos-version}";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = {self, nixpkgs, home-manager, ... }: {
		nixosConfigurations.nixos-wacquez = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.clemente = import ./home.nix;
						backupFileExtension = "bak";
					};
				}
			];
		};
	};
}
		
