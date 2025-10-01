{ config, ... }:

{
  wayland.windowManager.hyprland.settings = with config.pers.rice.currentTheme.hexS; {
    general = {
      gaps_in = if config.pers.themeName == "mocha-minimal" then 0 else 4;
      gaps_out = if config.pers.themeName == "mocha-minimal" then 0 else 8;
      border_size = if config.pers.themeName == "mocha-minimal" then 0 else 4;

      "col.active_border" = "rgb(${color5}) rgb(${color4})";
      "col.inactive_border" = "rgb(${color2}) rgb(${color3})";
    };

    decoration = {
      rounding = if config.pers.themeName == "mocha-minimal" then 0 else 10;

      active_opacity = "1.0";
      inactive_opacity = "1.0";

      blur = {
        enabled = config.pers.themeName != "mocha-minimal";
        size = "6";
        passes = "3";

        vibrancy = "0.1696";
      };
    };

    animations = {
      enabled = config.pers.themeName != "mocha-minimal";

      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };
  };
}
