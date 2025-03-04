{
  inputs,
  pkgs,
  lib,
}:

let
  makeConfig =
    extraModules:
    inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules =
        lib.pers.getFolderModules {
          folder = ./.;
          ignoreDefault = true;
        }
        ++ extraModules;
    };
in
(makeConfig [ ]).neovim.overrideAttrs (
  final: prev: { passthru.extend = extraModules: (makeConfig extraModules).neovim; }
)
