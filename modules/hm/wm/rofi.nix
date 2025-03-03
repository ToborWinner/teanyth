{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.rofi.enable = lib.mkEnableOption "rofi";

  config = lib.mkIf config.pers.rofi.enable {
    assertions = lib.singleton {
      assertion = config.pers.wayland.enable;
      message = "Currently, wayland support must be enabled for Rofi-wayland to be enabled.";
    };

    pers.info.menu = "rofi -show drun -show-icons";

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
  };
}
