{ inputs, lib, ... }:
let
  haumeaLibModule = {
    _module.args.haumea = inputs.haumea.lib;
  };

  haumeaModule = ./modules/haumea.nix;

in
{
  systems = lib.systems.flakeExposed;

  imports = [
    haumeaLibModule
    haumeaModule
    inputs.nixpkgs.flakeModules.default
  ];

  perSystem = ./perSystem.nix;

  flake = {
    flakeModules = {
      default = ./flakeModule.nix;
    };
  };
}
