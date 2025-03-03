{
  lib,
  config,
  osConfig,
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
    assertions = singleton {
      assertion = osConfig.pers.wayland.enable;
      message = "Wayland System-level support must be enabled for the home-manager module to be enabled.";
    };

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
