{ lib, config, ... }:

with lib;

{
  pers.waybar.enable = true;

  programs.waybar = {
    style =
      (concatMapAttrsStringSep "\n" (n: v: "@define-color ${n} ${v};") config.pers.rice.currentTheme.hex)
      + "\n"
      + builtins.readFile ./style.css;
    settings = [
      {
        height = 50;
        layer = "top";
        spacing = 4;
        margin-top = 5;
        margin-right = 14;
        margin-left = 14;
        margin-bottom = 0;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-right = [
          "pulseaudio"
          "memory"
          "battery"
          "backlight"
          "clock"
        ];

        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        backlight = {
          format = "{percent}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          tooltip-format = "{timeTo} H: {health}% C: {cycles}";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
        };

        memory = {
          format = "{used:0.2f}G 󰍛  {swapUsed:0.2f}G 󰾴";
          tooltip-format = "{used:0.2f}G/{total:0.2f}G ({percentage}%) {swapUsed:0.2f}G/{swapTotal:0.2f}G ({swapPercentage}%)";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = " {icon}";
          format-muted = " Muted ({volume}%)";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              " "
              " "
              " "
            ];
          };
        };

        "hyprland/workspaces" = {
          show-special = true;
        };
      }
    ];
  };
}
