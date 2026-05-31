# Catppuccin-Mocha.conf
{ config, lib, ... }:

{
  programs.kitty = {
    themeFile = lib.mkIf (config.pers.themeName == "mocha-minimal") "Catppuccin-Mocha";

    settings = lib.mkMerge [
      {
        cursor_trail = 1;
        confirm_os_window_close = 0;
        font_size = 20;
      }
      (lib.mkIf (config.pers.themeName != "mocha-minimal") (
        with config.pers.rice.currentTheme.hex;
        {
          inherit
            color0
            color1
            color2
            color3
            color4
            color5
            color6
            color7
            color8
            color9
            color10
            color11
            color12
            color13
            color14
            color15
            background
            foreground
            ;

          background_opacity = 0.6;
        }
      ))
    ];
  };
}
