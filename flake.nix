{
  description = "flakeWorld: Objectifying nix flakes - Nix library for KriomOS";

  inputs = {
    systems = { type = "indirect"; id = "systems"; };
    lib = { type = "indirect"; id = "lib"; };
    nixpkgs = { type = "indirect"; id = "nixpkgs"; };
    flake-utils = { type = "indirect"; id = "flake-utils"; };
    call-flake = { type = "indirect"; id = "call-flake"; };
    nosys = { type = "indirect"; id = "nosys"; };
    blank = { type = "indirect"; id = "blank"; };

    devshell = {
      type = "indirect";
      id = "devshell";
      inputs = {
        systems.follows = "systems";
        nixpkgs.follows = "nixpkgs";
      };
    };

    paisano = {
      type = "indirect";
      id = "paisano";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        yants.follows = "yants";
      };
    };

    paisano-tui = {
      type = "indirect";
      id = "paisano-tui";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        std.follows = "std";
      };
    };

    dmerge = {
      type = "indirect";
      id = "dmerge";
      inputs = {
        nixlib.follows = "lib";
        haumea.follows = "haumea";
        yants.follows = "yants";
      };
    };

    incl = {
      type = "indirect";
      id = "incl";
      inputs = { nixlib.follows = "lib"; };
    };

    nixago = {
      type = "indirect";
      id = "nixago";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    yants = {
      type = "indirect";
      id = "yants";
      inputs.nixpkgs.follows = "lib";
    };

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
        haumea = {
          inputs = { nixpkgs.follows = "lib"; };
          follows = "haumea";
        };
        nixago.follows = "nixago";
        nixpkgs.follows = "nixpkgs";
        yants.follows = "yants";
        incl.inputs.nixlib.follows = "lib";
        dmerge = {
          inputs = {
            nixlib.follows = "lib";
            haumea.follows = "haumea";
            yants.follows = "yants";
          };
        };
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
          (functions "make")
        ];
      }
      {
        devShells = std.harvest self [ "_local" "shell" ];
        make = std.harvest self [ "public" "make" ];
      };
}

  
