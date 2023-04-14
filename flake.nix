{
  description = "A world of nix flakes";

  inputs = {
    nixpkgs = { type = "indirect"; id = "nixpkgs"; };

    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      type = "indirect";
      id = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      (import ./flakePart.nix);
}
