{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.rofi.enable = lib.mkEnableOption "rofi";

  config = lib.mkIf config.pers.rofi.enable {
    # TODO: Don't escape here, instead in hyprland
    pers.info.menu = "rofi -show drun -show-icons -run-command '{cmd}' -modes \\\"drun,emoji,window,ssh\\\"";

    programs.rofi = {
      modes = [
        "drun"
        "emoji"
        "window"
        "ssh"
      ];

      plugins = [ pkgs.rofi-emoji ];

      enable = true;
    };
  };
}
