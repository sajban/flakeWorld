{ inputs, cell }:
let
  l = lib // builtins;
  inherit (inputs) nixpkgs lib std;

in
{
  simple = inputs@{ self, ... }:
    std.growOn
      {
        inherit inputs;
        cellsFrom = self.outPath + /cells;
        cellBlocks = with std.blockTypes; [
          (devshells "shell")
          (nixago "configs")
        ];
      }
      {
        devShells = std.harvest self [ "dev" "shell" ];
      };
}
