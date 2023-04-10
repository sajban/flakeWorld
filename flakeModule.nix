{ config, self, lib, flake-parts-lib, ... }:

let
  inherit (lib)
    dontRecurseIntoAttrs
    mkOption
    types;

  inherit (flake-parts-lib)
    mkPerSystemOption;

  uyrld = mkUyrld { inherit pkgs kor lib system hob neksysNames; };

in
{
  options = { };
}
