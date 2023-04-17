{ config, self, lib, flake-parts-lib, haumea-lib, ... }:
let
  inherit (flake-parts-lib)
    mkPerSystemOption mkFlake;

  inherit (haumea-lib)
    load loaders;

  finalMkSubworld = { inputs, module, root, ... }:
    mkFlake { inherit inputs; } {
      systems = lib.systems.flakeExposed;

      imports = [ ];

      perSystem = { pkgs, ... }: {
        packages = load {
          inputs = pkgs;
          src = root;
          loader = loaders.callPackage;
        };
      };
    };

  mkSubWorldByType = {
    default = finalMkSubworld { };
  };

  mkSubWorld =
    { type ? null
    , inputs ? { }
    , module ? null
    , root ? null
    }@args:
    let
      throwNoSubWorldFileError = "Missing subWorld.nix file";
      throwNoRootError = "Missing `root` argument";
      mkTypeFromSubWorldFile = if root != null then { } else throwNoSubWorldFileError;
      mkTypeFromRoot = if root != null then mkTypeFromSubWorldFile else throwNoRootError;
      type = if args.type != null then args.type else mkTypeFromRoot;
    in
    mkSubWorldByType."${type}" args;

in
{
  flake.lib = {
    inherit mkSubWorld;
  };
}
