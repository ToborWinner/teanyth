{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.neovim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf config.pers.neovim.enable {
    home.sessionVariables.EDITOR = "nvim";

    home.packages = [ pkgs.pers.neovim ];
  };
}
