{
  file,
  nixpkgs,
}:
let
  lib = import (nixpkgs + "/lib");
  evalConfig = import (nixpkgs + "/nixos/lib/eval-config.nix");
  modulesPath = nixpkgs + "/nixos/modules";
in
{
  evalWithBaseModules =
    baseModules:
    evalConfig {
      inherit baseModules lib;
      system = null;
      modules = [ file ];
      extraModules = [ ];
    };

  inherit lib modulesPath;

  baseModules = import (modulesPath + "/module-list.nix");

  additionalKeys = [ (modulesPath + "/misc/meta.nix") ];

  seqEvaluateOutputs =
    configuration:
    builtins.seq (
      builtins.seq configuration.config.system.build.toplevel.outPath configuration.config.system.build.vm.outPath
    );
}
