{ self, inputs, lib, flake-parts-lib, ... }:
let
  haumeaLibModule = {
    _module.args.haumea-lib = inputs.haumea.lib;
  };

  haumeaModule = ./modules/haumea.nix;

in
{
  systems = lib.systems.flakeExposed;

  imports = [
    haumeaLibModule
    haumeaModule
    inputs.nixpkgs.flakeModules.default
    ./flakeModule.nix
  ];

  perSystem = ./perSystem.nix;

  flake = {
    flakeModules = {
      default = ./flakeModule.nix;
    };

    lib = {
      inherit (self.flake) mkSubWorld;
    };
  };
}
