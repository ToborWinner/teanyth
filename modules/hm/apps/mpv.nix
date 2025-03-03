{ lib, config, ... }:

{
  options.pers.mpv.enable = lib.mkEnableOption "mpv";

  config.programs.mpv.enable = config.pers.mpv.enable;
}
