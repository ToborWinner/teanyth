{ lib, config, ... }:

{
  options.pers.hyprlock.enable = lib.mkEnableOption "hyprlock";

  config.programs.hyprlock = lib.mkIf config.pers.hyprlock.enable { enable = true; };
}
