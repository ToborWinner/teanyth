{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

{
  pers.waybar.enable = true;

  home.packages = [ pkgs.nerd-fonts._0xproto ]; # For https://github.com/sejjy/mechabar

  programs.waybar = {
    style =
      if config.pers.themeName == "mocha-minimal" then
        ./style-mocha-minimal.css
      else
        (concatMapAttrsStringSep "\n" (n: v: "@define-color ${n} ${v};") config.pers.rice.currentTheme.hex)
        + "\n"
        + builtins.readFile ./style.css;
    settings =
      if config.pers.themeName == "mocha-minimal" then
        [
          {
            # A lot taken from https://github.com/sejjy/mechabar
            height = 0;
            width = 0;
            margin = "0";
            spacing = 0;
            mode = "dock";

            modules-left = [
              # "group/theme_switcher"
              "custom/left_div#1"
              "hyprland/workspaces"
              "custom/right_div#1"
              "hyprland/submap"
              "hyprland/windowcount"
              "hyprland/window"
            ];

            modules-right = [
              "custom/left_div#2"
              # "temperature"
              "custom/left_div#3"
              "memory#swap"
              "custom/left_div#4"
              "memory#ram"
              # "cpu"
              "custom/left_inv#1"
              "custom/left_div#5"
              "custom/distro"
              "custom/right_div#2"
              "custom/right_inv#1"
              "clock#time"
              "custom/right_div#3"
              "clock#date"
              "custom/right_div#4"
              "network"
              "custom/right_div#5"

              # "mpris"
              "custom/left_div#6"
              "group/pulseaudio"
              "custom/left_div#7"
              "backlight"
              "custom/left_div#8"
              "battery"
              "custom/left_inv#2"
              "custom/power_menu"
            ];

            # Skipped main: bluetooth, idle_inhibitor, mpris, temperature
            # Skipped extras: all
            # Skipped custom: system_update, theme_switcher

            backlight = {
              format = "{icon} {percent}%";
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
              min-length = 7;
              max-length = 7;
              tooltip = false;
            };

            battery = {
              states = {
                warning = 20;
                critical = 10;
              };
              format = "{icon} {capacity}%";
              format-time = "{H} hr {M} min";
              format-icons = [
                "󰂎"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
              format-charging = "󰉁 {capacity}%";
              min-length = 7;
              max-length = 7;
              tooltip-format = "Discharging: {time} H: {health}% C: {cycles}";
              tooltip-format-charging = "Charging: {time} H: {health}% C: {cycles}";
              events = {
                # TODO: Find out if you can send more notifications, such as connected, disconnected and 89%
                on-discharging-warning = "notify-send 'Low Battery' '20% battery remaining'";
                on-discharging-critical = "notify-send 'Low Battery' '10% battery remaining' -u critical";
                on-charging-100 = "notify-send 'Battery full' 'Battery is at 100%'";
              };
            };

            "clock#time" = {
              format = "{:%H:%M}";
              min-length = 5;
              max-length = 5;
              tooltip-format = "Standard Time: {:%I:%M %p}";
            };

            "clock#date" = {
              format = "󰸗 {:%m-%d}";
              min-length = 8;
              max-length = 8;
              tooltip-format = "{calendar}";
              calendar = {
                mode = "month";
                mode-mon-col = 6;
                format = {
                  months = "<span alpha='100%'><b>{}</b></span>";
                  days = "<span alpha='90%'>{}</span>";
                  weekdays = "<span alpha='80%'><i>{}</i></span>";
                  today = "<span alpha='100%'><b><u>{}</u></b></span>";
                };
              };
              "actions" = {
                on-click = "mode";
              };
            };

            cpu = {
              interval = 10;
              format = "󰍛 {usage}%";
              format-warning = "󰀨 {usage}%";
              format-critical = "󰀨 {usage}%";
              min-length = 7;
              max-length = 7;
              states = {
                warning = 75;
                critical = 90;
              };
              tooltip = false;
            };

            "memory#ram" = {
              interval = 10;
              format = "󰘚 {percentage}%";
              format-warning = "󰀧 {percentage}%";
              format-critical = "󰀧 {percentage}%";
              states = {
                warning = 75;
                critical = 90;
              };
              min-length = 7;
              max-length = 7;
              tooltip-format = "Memory Used: {used:0.2f} GB / {total:0.2f} GB";
            };

            "memory#swap" = {
              interval = 10;
              format = "󰘚 {swapPercentage}%";
              min-length = 7;
              max-length = 7;
              tooltip-format = "Swap Used: {swapUsed:0.2f} GB / {swapTotal:0.2f} GB";
            };

            network = {
              interval = 10;
              format = "󰤨";
              format-ethernet = "󰈀";
              format-wifi = "{icon}";
              format-disconnected = "󰤯";
              format-disabled = "󰤮";
              format-icons = [
                "󰤟"
                "󰤢"
                "󰤥"
                "󰤨"
              ];
              min-length = 2;
              max-length = 2;
              tooltip-format = "Gateway: {gwaddr}";
              tooltip-format-ethernet = "Interface: {ifname}";
              tooltip-format-wifi = "Network: {essid}\nStrength: {signalStrength}%\nFrequency: {frequency} GHz";
              tooltip-format-disconnected = "Wi-Fi Disconnected";
              tooltip-format-disabled = "Wi-Fi Disabled";
            };

            # TODO: Look into not using pulseaudio
            "group/pulseaudio" = {
              orientation = "horizontal";
              modules = [
                "pulseaudio#output"
                "pulseaudio#input"
              ];
              drawer = {
                transition-left-to-right = false;
              };
            };

            "pulseaudio#output" = {
              format = "{icon} {volume}%";
              format-muted = "{icon} {volume}%";
              format-icons = {
                default = [
                  "󰕿"
                  "󰖀"
                  "󰕾"
                ];
                default-muted = "󰝟";
                headphone = "󰋋";
                headphone-muted = "󰟎";
                headset = "󰋎";
                headset-muted = "󰋐";
              };
              min-length = 7;
              max-length = 7;
              tooltip-format = "Output Device: {desc}";
            };

            "pulseaudio#input" = {
              format = "{format_source}";
              format-source = "󰍬 {volume}%";
              format-source-muted = "󰍭 {volume}%";
              min-length = 7;
              max-length = 7;
              tooltip-format = "Input Device: {desc}";
            };

            "hyprland/window" = {
              format = "{}";
              rewrite = {
                "" = "Desktop";
                kitty = "Terminal";
                Alacritty = "Terminal";
                zsh = "Terminal";
                "~" = "Terminal";
              };
              swap-icon-label = false;
            };

            "hyprland/windowcount" = {
              format = "[{}]";
              swap-icon-label = false;
            };

            "hyprland/workspaces" = {
              format = "{icon}";
              format-icons = {
                active = "";
                default = "";
              };
              persistent-workspaces = {
                "*" = 5;
              };
              show-special = true;
              cursor = true;
            };

            "custom/distro" = {
              format = "";
              tooltip = false;
            };

            "custom/left_div#1" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div#2" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div#3" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div#4" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div#5" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div#6" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div#7" = {
              format = "";
              tooltip = false;
            };
            "custom/left_div#8" = {
              format = "";
              tooltip = false;
            };
            "custom/left_inv#1" = {
              format = "";
              tooltip = false;
            };
            "custom/left_inv#2" = {
              format = "";
              tooltip = false;
            };
            "custom/right_div#1" = {
              format = "";
              tooltip = false;
            };
            "custom/right_div#2" = {
              format = "";
              tooltip = false;
            };
            "custom/right_div#3" = {
              format = "";
              tooltip = false;
            };
            "custom/right_div#4" = {
              format = "";
              tooltip = false;
            };
            "custom/right_div#5" = {
              format = "";
              tooltip = false;
            };
            "custom/right_inv#1" = {
              format = "";
              tooltip = false;
            };

            "custom/power_menu" = {
              format = "󰤄";
              tooltip-format = "Power Menu";
              on-click = "wlogout";
            };

            "hyprland/submap" = {
              format = "{}";
              tooltip = false;
            };
          }
        ]
      else
        [
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
