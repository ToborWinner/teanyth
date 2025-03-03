lib:

let
  modules = lib.pers.getFolderModules {
    folder = ./.;
    ignoreDefault = true;
  };
in
builtins.map (x: lib.pers.wrapModuleWithPkgs x) modules
