{ kor, pkgs, lib, hob, system, neksysNames }:
let
  inherit (builtins) hasAttr mapAttrs concatStringsSep elem readDir;
  inherit (kor) mkLambda optionalAttrs genAttrs;
  inherit (world) pkdjz mkZolaWebsite;

  mkTypedZolaWebsite = name: flake: mkZolaWebsite {
    src = flake;
    name = flake.name or name;
  };

  mkSubWorld = SubWorld@{ lambda, modz, self ? src, src ? self, subWorlds ? { } }:
    let
      inherit (builtins) getAttr elem;

      Modz = [
        "pkgs"
        "pkgsStatic"
        "pkgsSet"
        "hob"
        "pkdjz"
        "world"
        "worldSet"
      ];

      useMod = genAttrs Modz (n: (elem n modz));

      /* Warning: sets shadowing */
      closure = optionalAttrs useMod.pkgs pkgs
        // optionalAttrs useMod.pkgsStatic pkgs.pkgsStatic
        // optionalAttrs useMod.world world
        // optionalAttrs useMod.pkdjz pkdjz
        // optionalAttrs useMod.hob { inherit hob; }
        // optionalAttrs useMod.pkgsSet { inherit pkgs; }
        // optionalAttrs useMod.worldSet { inherit world; }
        // subWorlds
        // { inherit kor lib; }
        // { inherit system; }
        # TODO: deprecate `self` for `src`
        // { inherit self; }
        // { src = self; };

    in
    mkLambda { inherit closure lambda; };

  mkWorldFunction = flake: mkSubWorld {
    modz = [ "pkgs" "pkdjz" ];
    src = flake;
    lambda = flake.function;
  };

  mkSource = spokNeim: flake@{ ... }:
    let
      preMakeSubWorld = neim: SubWorld@{ modz ? [ ], lambda, ... }:
        let
          src = SubWorld.src or (SubWorld.self or flake);
          self = src;
        in
        mkSubWorld { inherit src self modz lambda; };

      preMakeHubWorld = neim: HobUyrld@{ modz ? [ "pkgs" ], lambda, ... }:
        let
          implaidSelf = hob.${neim} or null;
          src = HobUyrld.src or (HobUyrld.self or implaidSelf);
          self = src;
        in
        mkSubWorld { inherit src self modz lambda; };

      mkHubWorlds = HobUyrldz:
        let
          priHobUyrldz = HobUyrldz hob;
        in
        mapAttrs preMakeHubWorld priHobUyrldz;

      mkSubWorlds = SubWorldz:
        let
          preMakeSubWorldz = neim: SubWorld@{ modz ? [ ], lambda, ... }:
            let
              src = SubWorld.src or (SubWorld.self or flake);
              self = src;
            in
            mkSubWorld { inherit src self modz lambda subWorlds; };

          subWorlds = mapAttrs preMakeSubWorldz SubWorldz;
        in
        subWorlds;

      mkNeksysWebpageName = neksysNeim:
        [ (neksysNeim + "Webpage") (neksysNeim + "Website") ];

      neksysWebpageSpokNames = lib.concatMap mkNeksysWebpageName neksysNames;

      isWebpageSpok = spokNeim:
        elem spokNeim neksysWebpageSpokNames;

      mkWebpageFleik = Webpage@{ src ? flake, ... }:
        let
          SubWorld = {
            inherit src;
            modz = [ "pkdjz" ];
            lambda = { mkWebpage }:
              mkWebpage Webpage;
          };
        in
        mkSubWorld SubWorld;

      optionalSystemAttributes = {
        defaultPackage = flake.defaultPackage.${system} or { };
        packages = flake.packages.${system} or { };
        legacyPackages = flake.legacyPackages.${system} or { };
      };

      hasFleikFile =
        let flakeDirectoryFiles = readDir flake; in
        hasAttr "flake.nix" flakeDirectoryFiles;

      makeFleik = { };

      typedFlakeMakerIndex = {
        firnWebpage = mkWebpageFleik { src = flake; };
        zolaWebsite = mkTypedZolaWebsite spokNeim flake;
        worldFunction = mkWorldFunction flake;
      };

      flakeTypeExists = hasAttr flake.type typedFlakeMakerIndex;

      mkTypedFlake = typedFlakeMakerIndex."${flake.type}";

    in
    if (hasAttr "type" flake) then mkTypedFlake
    else if (hasAttr "HobUyrldz" flake)
    then mkHubWorlds flake.HobUyrldz
    else if (hasAttr "HobUyrld" flake)
    then preMakeHubWorld spokNeim (flake.HobUyrld hob)
    else if (hasAttr "SubWorldz" flake)
    then mkSubWorlds flake.SobUyrldz
    else if (hasAttr "SubWorld" flake)
    then preMakeSubWorld spokNeim flake.SobUyrld
    else if (isWebpageSpok spokNeim)
    then mkZolaWebsite { src = flake; }
    else if hasFleikFile then makeFleik
    else flake // optionalSystemAttributes;

  world = mapAttrs mkSource hob;

in
world
