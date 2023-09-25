{ inputs, cell }:
let
  l = lib // builtins;
  inherit (inputs) nixpkgs lib std;

in
{
  simple = inputs@{ self, ... }:
    std.growOn
      {
        inputs = inputs // { inherit std; };
        cellsFrom = self + /cells;
        cellBlocks = with std.blockTypes; [
          (devshells "shell")
          (nixago "configs")
        ];
      }
      {
        devShells = std.harvest self [ "dev" "shell" ];
      };

  simpleWrapperFlake = inputs@{ self, ... }:
    std.growOn
      {
        inputs = inputs // { inherit std nixpkgs; };
        cellsFrom = self + /cells;
        cellBlocks = with std.blockTypes; [
          (devshells "shell")
          (nixago "configs")
        ];
      }
      {
        devShells = std.harvest self [ "dev" "shell" ];
      };
}
