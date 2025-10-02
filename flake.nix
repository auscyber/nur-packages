{
  description = "My personal NUR repository";
  inputs.karabiner-branch.url = "github:auscyber/nixpkgs/karabiner-driver-fix";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      legacyPackages = forAllSystems (
        system:
        import ./packages.nix {
          inherit inputs;
          pkgs = import nixpkgs { inherit system; };
        }
      );
      overlays.default = import ./overlay.nix inputs;
      packages = forAllSystems (
        system: (nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system})
      );
      apps = forAllSystems (system: {
        docs = {
          type = "app";
          program = builtins.toString (
            import ./docs rec {
              pkgs = import nixpkgs { inherit system; };
              lib = pkgs.lib;
            }
          );
        };
      });
      devShells = forAllSystems (system: {
        default =
          let
            pkgs = import nixpkgs { inherit system; };

          in
          pkgs.mkShellNoCC {
            packages = [
              pkgs.nvfetcher
            ];
          };
      });

    };
}
