{ config, ... }:

{
  pers.alacritty.enable = true;

  programs.alacritty = {
    settings = {
      font.size = 20;
      window.opacity = if config.pers.themeName == "mocha-minimal" then 1 else 0.6;

      colors =
        if config.pers.themeName == "mocha-minimal" then
          {
            indexed_colors = [
              {
                color = "#fab387";
                index = 16;
              }
              {
                color = "#f5e0dc";
                index = 17;
              }
            ];
            bright = {
              black = "#585b70";
              blue = "#89b4fa";
              cyan = "#94e2d5";
              green = "#a6e3a1";
              magenta = "#f5c2e7";
              red = "#f38ba8";
              white = "#a6adc8";
              yellow = "#f9e2af";
            };
            cursor = {
              cursor = "#f5e0dc";
              text = "#1e1e2e";
            };
            footer_bar = {
              background = "#a6adc8";
              foreground = "#1e1e2e";
            };
            hints = {
              end = {
                background = "#a6adc8";
                foreground = "#1e1e2e";
              };
              start = {
                background = "#f9e2af";
                foreground = "#1e1e2e";
              };
            };
            normal = {
              black = "#45475a";
              blue = "#89b4fa";
              cyan = "#94e2d5";
              green = "#a6e3a1";
              magenta = "#f5c2e7";
              red = "#f38ba8";
              white = "#bac2de";
              yellow = "#f9e2af";
            };
            primary = {
              background = "#1e1e2e";
              bright_foreground = "#cdd6f4";
              dim_foreground = "#7f849c";
              foreground = "#cdd6f4";
            };
            search = {
              focused_match = {
                background = "#a6e3a1";
                foreground = "#1e1e2e";
              };
              matches = {
                background = "#a6adc8";
                foreground = "#1e1e2e";
              };
            };
            selection = {
              background = "#f5e0dc";
              text = "#1e1e2e";
            };
            vi_mode_cursor = {
              cursor = "#b4befe";
              text = "#1e1e2e";
            };
          }
        else
          with config.pers.rice.currentTheme.hex;
          {
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
