{ self, inputs, lib, flake-parts-lib, ... }:
let
  libsModule = {
    _module.args = {
      haumea-lib = inputs.haumea.lib;
      flakeWorldLib = self.flake.lib;
    };
  };

  haumeaModule = ./modules/haumea.nix;

in
{
  systems = lib.systems.flakeExposed;

  imports = [
    libsModule
    haumeaModule
    inputs.nixpkgs.flakeModules.default
    ./flakeModule.nix
  ];

  perSystem = ./perSystem.nix;

  flake = {
    main = { };

    flakeModules = {
      default = ./flakeModule.nix;
    };

    lib = {
      inherit (self.flake) mkSubWorld;
    };
  };
}
