{
  name,
  flakedata,
  importFlakePath,
  ifd ? { },
}:
let
  flake = (import importFlakePath).importFlake flakedata;
  lib = flake.lib;
  parsedIFD = ifd;
  modulesPath = flake.inputs.nixpkgs + "/nixos/modules";
in
{
  evalWithBaseModules =
    baseModules:
    flake.nixosConfigurations.${name}.override {
      baseModules = baseModules ++ [
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
        }
      ];
    };

  inherit modulesPath lib;
  baseModules = import lib.pers.reduce-modules.baseModulesPath;

  additionalKeys = [ (modulesPath + "/misc/meta.nix") ];

  seqEvaluateOutputs =
    configuration:
    builtins.seq (
      builtins.seq configuration.config.system.build.toplevel.outPath configuration.config.system.build.vm.outPath
    );
}
