{ lib, config, ... }:

{
  options.pers.btop.enable = lib.mkEnableOption "btop";

  config.programs.btop = lib.mkIf config.pers.btop.enable {
    enable = true;
    settings.vim_keys = true;
  };
}
