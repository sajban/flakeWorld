{
  description = "flakeWorld: Objectifying nix flakes - Nix library for KriomOS";

  inputs = {
    systems = { type = "indirect"; id = "systems"; };
    lib = { type = "indirect"; id = "lib"; };
    nixpkgs = { type = "indirect"; id = "nixpkgs"; };

    paisano = { type = "indirect"; id = "paisano"; };
    paisano-tui = { type = "indirect"; id = "paisano-tui"; };

    blank = { type = "indirect"; id = "blank"; };
    dmerge = { type = "indirect"; id = "dmerge"; };
    incl = { type = "indirect"; id = "incl"; };
    nixago = { type = "indirect"; id = "nixago"; };
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
        devshell.follows = "devshell";
        haumea.follows = "haumea";
        nixago.follows = "nixago";
        nixpkgs.follows = "nixpkgs";
        yants.follows = "yants";
      };
    };

    devshell = {
      type = "indirect";
      id = "devshell";
      inputs = {
        systems.follows = "systems";
        nixpkgs.follows = "nixpkgs";
      };
    };

  };

  outputs = inputs@{ self, std, ... }:
    std.growOn
      {
        inherit inputs;
        cellsFrom = ./cells;
        cellBlocks = with std.blockTypes; [
          (devshells "shell")
          (nixago "configs")
        ];
      }
      { devShells = std.harvest self [ "_local" "shell" ]; };
}

  
