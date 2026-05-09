{
  description = "Workout one-pager generator";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (s: f nixpkgs.legacyPackages.${s});
    in {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [ typst curl jq imagemagick ];
          shellHook = ''
            echo "workouts dev shell"
            echo "  scripts/search.sh <term>   look up an exercise id"
            echo "  scripts/fetch.sh           download images for mappings.toml"
            echo "  scripts/build.sh           compile workouts/*.typ -> dist/*.pdf"
          '';
        };
      });
    };
}
