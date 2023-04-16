{ config, self, lib, flake-parts-lib, haumea-lib, ... }:

let
  inherit (lib)
    dontRecurseIntoAttrs
    mkOption
    types;

  inherit (flake-parts-lib)
    mkPerSystemOption mkFlake;

  inherit (haumea-lib)
    load loaders;

  uyrld = mkUyrld { inherit pkgs kor lib system hob neksysNames; };

  defaultInputs = { };

  defaultModule = { self, inputs, lib, flake-parts-lib, ... }: {
    systems = lib.systems.flakeExposed;

    imports = [ ];

    perSystem = { pkgs, ... }: { };
  };

  functionTypeByName = {
    default = { inputs, module, root, ... }:
      mkFlake { inherit inputs; } {
        systems = lib.systems.flakeExposed;

        imports = [ ];

        perSystem = { pkgs, ... }: {
          config = {
            packages = load {
              inherit inputs;
              src = root;
              loader = loader.callPackage;
            };
          };
        };
      };
  };

  mkSubWorld =
    { type ? "default"
    , inputs ? defaultInputs
    , module ? defaultModule
    , root ? null
    }@args:
    functionTypeByName."${type}" args;

in
{
  options = { };

  flake = {
    inherit (config) mkSubworld;
  };
}
