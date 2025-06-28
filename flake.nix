{
  description = "My Personal Website, https://cebar.xyz";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        hugo
        go
      ];
    };
  };
}
