{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.rofi.enable = lib.mkEnableOption "rofi";

  config = lib.mkIf config.pers.rofi.enable {
    pers.info.menu = "rofi -show drun -show-icons -run-command 'uwsm app -- {cmd}' -modes \"drun,emoji,window,ssh\"";

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
