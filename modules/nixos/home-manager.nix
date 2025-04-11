{
  lib,
  config,
  inputs,
  settings,
  sharedInfo,
  hostname,
  options,
  pkgs,
  ...
}@args:

{
  imports =
    let
      normalBaseModules = import (inputs.home-manager + "/modules/modules.nix") {
        inherit pkgs;
        lib = extendedLib;
        useNixpkgsModule = !cfg.useGlobalPkgs;
      };

      reducedFor =
        name:
        lib.pers.reduce-modules.useReducedImports (import ../../hosts/${hostname}/reduced-hm-${name}.nix)
          modulesPath
          normalBaseModules;

      baseModulesFor =
        name:
        if config.pers.home-manager.noBaseModules then
          [ ]
        else if config.pers.home-manager.reduced then
          reducedFor name
        else
          normalBaseModules;

      callWithArgs =
        f: f (builtins.mapAttrs (n: _: args.${n} or config._module.args.${n}) (lib.functionArgs f));
      defaultFile = import inputs.home-manager.nixosModules.home-manager;
      commonFileName = inputs.home-manager + "/nixos/common.nix";
      commonFile = import commonFileName;
      default = callWithArgs defaultFile;
      common = callWithArgs commonFile;
      patchedDefault = (builtins.removeAttrs default [ "imports" ]) // {
        _file = inputs.home-manager.nixosModules.home-manager;
      };
      patchedCommon =
        lib.recursiveUpdateUntil
          (
            path: _: _:
            path == [
              "options"
              "home-manager"
              "users"
              "type"
            ]
          )
          common
          {
            _file = commonFileName;

            options.home-manager.users.type = lib.types.attrsOf hmModule;
          };

      cfg = config.home-manager;

      modulesPath = inputs.home-manager + "/modules";

      extendedLib = import (inputs.home-manager + "/modules/lib/stdlib-extended.nix") lib;

      # Edited from https://github.com/nix-community/home-manager/blob/79461936709b12e17adb9c91dd02d1c66d577f09/nixos/common.nix#L25
      hmModule = lib.types.submoduleWith {
        description = "Home Manager module";
        class = "homeManager";
        specialArgs = {
          inherit modulesPath;
          lib = extendedLib;
          osConfig = config;
        } // cfg.extraSpecialArgs;
        modules = [
          (
            { name, ... }:
            {
              imports = baseModulesFor name;

              config = {
                submoduleSupport.enable = true;
                submoduleSupport.externalPackageInstall = cfg.useUserPackages;
                home.username = config.users.users.${name}.name;
                home.homeDirectory = config.users.users.${name}.home;
                nix.enable = config.nix.enable;
                nix.package = config.nix.package;
              };
            }
          )
        ] ++ cfg.sharedModules;
      };
    in
    [
      patchedDefault
      patchedCommon
    ];

  options.pers.home-manager = {
    enable = lib.mkEnableOption "home-manager";

    imports = lib.mkOption {
      description = "List of imports to include in the home-manager configuration";
      type = with lib.types; listOf deferredModule;
      default = [ ];
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      description = "State version to set in home manager";
      default = config.system.stateVersion;
    };

    reduced = lib.mkEnableOption "using a reduced base module list";

    # Used when making the reduced module list
    noBaseModules = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "When set to true, base modules are not imported for all users.";
      internal = true;
    };
  };

  config = lib.mkIf config.pers.home-manager.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.${settings.username} =
      { ... }:
      {
        imports = config.pers.home-manager.imports;

        home.stateVersion = config.pers.home-manager.stateVersion;

        pers.isStandalone = lib.mkOverride 0 false;

        pers.info.getIFD = name: config.pers.info.getIFD "${settings.username}-${name}";
      };
    home-manager.extraSpecialArgs = {
      inherit
        inputs
        settings
        sharedInfo
        hostname
        ;
      osOptions = options;
    };

    pers.info.ifd = lib.mapAttrs' (
      n: v: lib.nameValuePair "${settings.username}-${n}" v
    ) config.home-manager.users.${settings.username}.pers.info.ifd;

    pers.home-manager.imports = lib.flatten [
      (inputs.sensitive + "/hm.nix")
      (import ../../core/hm)
      (import ../hm lib)
      (import ../../rices lib)
    ];
  };
}
