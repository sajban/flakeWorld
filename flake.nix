{
  description = "flakeWorld: Objectifying nix flakes - Nix library for KriomOS";

  inputs = {
    blank = { type = "indirect"; id = "blank"; };
    incl = { type = "indirect"; id = "incl"; };
    lib = { type = "indirect"; id = "lib"; };
    nixpkgs = { type = "indirect"; id = "nixpkgs"; };
    paisano = { type = "indirect"; id = "paisano"; };
    paisano-tui = { type = "indirect"; id = "paisano-tui"; };
    dmerge = { type = "indirect"; id = "dmerge"; };
    yants = { type = "indirect"; id = "yants"; };

    haumea = {
      type = "indirect";
      id = "haumea";
      inputs.nixpkgs.follows = "lib";
    };

    flake-parts = {
      type = "indirect";
      id = "flake-parts";
      inputs.nixpkgs-lib.follows = "lib";
    };

    std = {
      type = "indirect";
      id = "std";
      inputs = {
        blank.follows = "blank";
        haumea.follows = "haumea";
        nixpkgs.follows = "nixpkgs";
        yants.follows = "yants";
      };
    };
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      (import ./flakePart.nix);
}
