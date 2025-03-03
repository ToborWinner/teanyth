{ lib, config, ... }:

{
  options.pers.btop.enable = lib.mkEnableOption "btop";

  config.programs.btop.enable = config.pers.btop.enable;
}
