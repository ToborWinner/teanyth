{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.hypridle.enable = lib.mkEnableOption "hypridle";

  config = lib.mkIf config.pers.hypridle.enable {
    assertions = lib.singleton {
      assertion = config.pers.hyprland.enable;
      message = "Hyprland must be enabled for hypridle to be enabled";
    };

    home.packages = [ pkgs.brightnessctl ];

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 150; # 2.5min.
            on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "brightnessctl -r"; # monitor backlight restore.
          }
          {
            timeout = 300; # 5min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }
          {
            timeout = 330; # 5.5min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
          }
          {
            timeout = 1800; # 30min
            on-timeout = "systemctl suspend"; # suspend pc
          }
        ];
      };
    };
  };
}
