{ inputs, cell }:
let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs std;
  stdlib = std.lib;

in
l.mapAttrs (_: stdlib.dev.mkShell) rec {
  default = { ... }: {
    name = "Standard";
    nixago = [
      ((stdlib.dev.mkNixago stdlib.cfg.conform)
        { data = { inherit (inputs) cells; }; })
      ((stdlib.dev.mkNixago stdlib.cfg.treefmt)
        cell.configs.treefmt)
      ((stdlib.dev.mkNixago stdlib.cfg.editorconfig)
        cell.configs.editorconfig)
      ((stdlib.dev.mkNixago stdlib.cfg.githubsettings)
        cell.configs.githubsettings)
      (stdlib.dev.mkNixago stdlib.cfg.lefthook)
      (stdlib.dev.mkNixago stdlib.cfg.adrgen)
      (stdlib.dev.mkNixago cell.configs.cog)
    ];
    commands =
      [
        {
          package = nixpkgs.reuse;
          category = "legal";
        }
        {
          package = nixpkgs.delve;
          category = "cli-dev";
          name = "dlv";
        }
        {
          package = nixpkgs.go;
          category = "cli-dev";
        }
        {
          package = nixpkgs.gotools;
          category = "cli-dev";
        }
        {
          package = nixpkgs.gopls;
          category = "cli-dev";
        }
      ]
      ++ l.optionals nixpkgs.stdenv.isLinux [
        {
          package = nixpkgs.golangci-lint;
          category = "cli-dev";
        }
      ];
    imports = [ std.devshellProfiles.default book ];
  };

  book = { ... }: {
    nixago = [
      ((stdlib.dev.mkNixago stdlib.cfg.mdbook)
        cell.configs.mdbook)
    ];
  };
}
