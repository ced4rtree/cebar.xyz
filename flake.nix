{
  description = "My Personal Website, https://cebar.xyz";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    self.submodules = true; # tell nix to include the risotto theme submodule

  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ ... }: {
      systems = import inputs.systems;
      perSystem = { pkgs, system, self', ... }: {
        packages.cebar_xyz = pkgs.stdenvNoCC.mkDerivation {
          pname = "cebar.xyz";
          version = "1.0";

          src = ./.;

          buildInputs = [ pkgs.hugo ];

          buildPhase = ''
            hugo build -d output
          '';

          installPhase = ''
            mkdir -p $out
            cp -r output/* $out/
          '';
        };

        packages.default = self'.packages.cebar_xyz;

        devShells.${system}.default = pkgs.mkShell {
          packages = with pkgs; [
            hugo
            go
          ];
        };
      };
    });
}
