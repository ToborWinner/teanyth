{ lib, config, ... }:

{
  options.pers.zathura.enable = lib.mkEnableOption "zathura";

  config.programs.zathura.enable = config.pers.zathura.enable;
}
