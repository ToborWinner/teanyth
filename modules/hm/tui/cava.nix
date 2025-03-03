{ lib, config, ... }:

{
  options.pers.cava.enable = lib.mkEnableOption "cava";

  config.programs.cava.enable = config.pers.cava.enable;
}
