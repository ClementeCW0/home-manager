{
  description = "Input-leap client sandbox";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ pkgs.input-leap ];
        shellHook = ''
          exec input-leapc -f --disable-crypto 192.168.1.95
        '';
      };
    };
}
