{ lib, config, ... }:

{
  options.pers.waybar.enable = lib.mkEnableOption "waybar";

  config.programs.waybar = lib.mkIf config.pers.waybar.enable {
    enable = true;
    systemd.enable = true;
  };
}
