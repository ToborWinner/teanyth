{
  inputs,
  pkgs,
  lib,
}:

(inputs.nvf.lib.neovimConfiguration {
  inherit pkgs;
  modules = lib.pers.getFolderModules {
    folder = ./.;
    ignoreDefault = true;
  };
}).neovim
