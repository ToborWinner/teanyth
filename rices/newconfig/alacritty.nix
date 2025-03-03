{ config, ... }:

{
  pers.alacritty.enable = true;

  programs.alacritty = {
    settings = {
      font.size = 20;
      window.opacity = 0.6;

      colors = with config.pers.rice.currentTheme.hex; {
        primary = { inherit background foreground; };
        normal = {
          black = color0;
          red = color1;
          green = color2;
          yellow = color3;
          blue = color4;
          magenta = color5;
          cyan = color6;
          white = color7;
        };

        bright = {
          black = color8;
          red = color9;
          green = color10;
          yellow = color11;
          blue = color12;
          magenta = color13;
          cyan = color14;
          white = color15;
        };
      };
    };
  };
}
