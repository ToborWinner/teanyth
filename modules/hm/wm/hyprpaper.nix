{
  lib,
  config,
  osConfig,
  ...
}:

{
  options.pers.hyprpaper.enable = lib.mkEnableOption "hyprpaper";

  config = lib.mkIf config.pers.hyprpaper.enable {
    assertions = [
      {
        assertion = config.pers.wayland.enable;
        message = "Wayland support must be enabled for Hyprpaper to be enabled.";
      }
      {
        assertion =
          (config.pers.info.startupWallpaper != null)
          -> (builtins.elem config.pers.info.startupWallpaper config.pers.info.loadWallpapers);
        message = "pers.info.startupWallpaper must also be in pers.info.loadWallpapers for Hyprpaper to work.";
      }
    ];

    pers.info = {
      setWallpaperCommand =
        wp:
        lib.warnIfNot (builtins.elem wp config.pers.info.loadWallpapers)
          "Setting Hyprpaper's wallpaper with the command without preloading it won't work. Wallpaper Path: ${wp}."
          (
            let
              hmFinalPackage = config.wayland.windowManager.hyprland.finalPackage;
              package = if hmFinalPackage == null then osConfig.programs.hyprland.package else hmFinalPackage;
            in
            ''
              (
                XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
                if [[ -d "/tmp/hypr" || -d "$XDG_RUNTIME_DIR/hypr" ]]; then
                  for i in $(${package}/bin/hyprctl instances -j | jq ".[].instance" -r); do
                    ${package}/bin/hyprctl -i "$i" hyprpaper wallpaper ,${lib.escapeShellArg wp}
                  done
                fi
              )
            ''
          );
      wallpaperNeedsPreloading = true;
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = map (wp: toString wp) config.pers.info.loadWallpapers;
        wallpaper = [
          (lib.mkIf (config.pers.info.startupWallpaper != null) ",${config.pers.info.startupWallpaper}")
        ];
      };
    };
  };
}
