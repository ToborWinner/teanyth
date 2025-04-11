# TODO: This fails because of the patchForTheme, where the value of `home.file` depends on the config that comes from the submodule instead of the current one.
{
  name,
  user,
  flakedata,
  importFlakePath,
  ifd ? { },
}:
let
  flake = (import importFlakePath).importFlake flakedata;
  flakeLib = flake.lib;
  lib = payload.specialArgs.lib;
  parsedIFD = ifd;
  modulesPath = flake.inputs.nixpkgs + "/modules";

  nixosBaseModules = import flakeLib.pers.reduce-modules.baseModulesPath;

  baseModules = import (flake.inputs.home-manager + "/modules/modules.nix") {
    pkgs = configuration._module.args.pkgs;
    inherit lib;
    useNixpkgsModule = !configuration.config.home-manager.useGlobalPkgs;
  };

  configuration = flake.nixosConfigurations.${name}.override {
    baseModules = nixosBaseModules ++ [
      {
        # Avoid doing IFD in the build environment
        pers.info.getIFD = name: parsedIFD.${name};
        pers.home-manager.imports = [
          {
            # Avoid evaluating all options because of docs and avoid the IFD done in nvf in mnw
            pers.neovim.enable = lib.mkForce false;
            # TODO: Better way to fix
            # Avoid IFD done in swww
            pers.swww.enable = lib.mkForce false;
            pers.hyprpaper.enable = lib.mkForce true;
          }
        ];
        # Add base modules manually
        pers.home-manager.noBaseModules = true;
      }
    ];
  };

  option = configuration.options.home-manager.users;
  inherit (option.type.functor.payload.elemType.functor) payload;
  definedModules = builtins.concatMap (
    x: if x ? ${user} then [ x.${user} ] else [ ]
  ) option.definitions;
in
{
  evalWithBaseModules =
    baseModules:
    lib.evalModules {
      # name is added here: https://github.com/NixOS/nixpkgs/blob/e3832424a15fff6a218dfbf539c3964c0154b33c/lib/types.nix#L1217
      modules =
        baseModules
        ++ [ { _module.args.name = user; } ]
        ++ payload.modules
        ++ (builtins.trace payload.modules definedModules);
      inherit (payload) class specialArgs;
    };

  inherit modulesPath lib baseModules;

  seqEvaluateOutputs =
    configuration:
    builtins.deepSeq (
      builtins.seq configuration.config.home.activationPackage.outPath configuration.config.home.news
    );
}
