{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.pers.wayland;
in
{
  options.pers.wayland.enable = mkEnableOption "wayland";

  config = mkIf cfg.enable {
    home.sessionVariables = {
      GDK_BACKEND = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    home.packages = with pkgs; [ wl-clipboard ];
  };
}
