{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.pers.rice;

  filteredWallpapers = builtins.filter (w: w.colors == null) cfg.wallpapers;

  colorOpts = {
    hex = mkOption {
      description = "The current theme in hex.";
      internal = true;
      type = with types; attrsOf str;
      default = { };
    };

    hexS = mkOption {
      description = "The current theme in hex, but without the # prefix.";
      internal = true;
      type = with types; attrsOf str;
      default = { };
    };

    num = mkOption {
      description = "The current theme in hex.";
      internal = true;
      type = with types; attrsOf ints.unsigned;
      default = { };
    };
  };
in
{
  options.pers.rice = {
    enabled = mkOption {
      type = with types; nullOr str;
      description = "The rice that is currently enabled.";
      default = null;
    };

    wallpapers = mkOption {
      type =
        with types;
        listOf (
          types.submodule {
            options = {
              name = mkOption {
                type = pers.types.filename;
                description = "The name of the wallpaper.";
              };

              path = mkOption {
                type = path;
                description = "The path of the wallpaper.";
              };

              colors = mkOption {
                type = nullOr (submodule {
                  options = colorOpts;
                });
                default = null;
                description = "The colors to use. They may otherwise be generated automatically.";
              };
            };
          }
        );
      description = "List of wallpapers to use with this rice.";
    };

    themesFromWallpapers = mkEnableOption "generating themes from wallpapers.";

    colorBackend = mkOption {
      type = types.enum [ "wallust" ];
      description = "Which backend to use when generating themes from wallpapers.";
      default = "wallust";
    };

    currentTheme = colorOpts;
  };

  config = mkIf (cfg.enabled != null) {
    assertions = singleton {
      assertion =
        let
          rices = cfg.rices or { };
          countEnabled = foldlAttrs (
            acc: _: value:
            acc + (if value.enable then 1 else 0)
          ) 0 rices;
        in
        countEnabled == 1;
      message = "Only one rice can be enabled at a time. Currently enabled rices: ${
        concatStringsSep ", " (attrNames (filterAttrs (_: v: v.enable) (cfg.rices or { })))
      }.";
    };

    pers.rice.rices.${cfg.enabled}.enable = true;

    pers.theme =
      let
        mkTheme = name: path: colors: {
          configuration.pers = {
            rice.currentTheme =
              if colors != null then colors else config.pers.info.getIFD "${name}-current-theme";
            info.startupWallpaper =
              if config.pers.info.wallpaperNeedsPreloading then
                path
              else
                "${config.home.homeDirectory}/.local/state/home-manager/gcroots/current-theme/wallpaper";
            extraThemeActivation = config.pers.info.setWallpaperCommand path;
            extraThemePackageCommands = mkIf (
              !config.pers.info.wallpaperNeedsPreloading
            ) "ln -s ${escapeShellArg path} $out/wallpaper";
            themeName = name;
          };
        };
      in
      mkIf cfg.themesFromWallpapers (
        listToAttrs (
          map (wp: nameValuePair wp.name (mkTheme wp.name "${wp.path}" wp.colors)) cfg.wallpapers
        )
      );

    pers.info.ifd =
      let
        mkThemeIfd =
          path: mkIf (cfg.colorBackend == "wallust") (import ./wallust.nix { inherit lib pkgs path; });
      in
      mkIf cfg.themesFromWallpapers (
        listToAttrs (
          map (wp: nameValuePair "${wp.name}-current-theme" (mkThemeIfd "${wp.path}")) filteredWallpapers
        )
      );

    pers.info.loadWallpapers = mkIf cfg.themesFromWallpapers (map (wp: "${wp.path}") cfg.wallpapers);

    pers.rofi-wallpaper-picker.wallpapers = mkIf cfg.themesFromWallpapers (
      map (wp: {
        # We cannot directly add the path to themePackage because it would lead to infinite recursion:
        # Hyprland needs rofi-wallpaper-picker's path, which needs the themePackage path,
        # which needs the list of changed home.file, which include Hyprland's configuration,
        # therefore causing infinite recursion.
        command = "${config.home.homeDirectory}/.local/state/home-manager/gcroots/current-home/theme/${escapeShellArg wp.name}/activate";
        path = "${wp.path}";
      }) cfg.wallpapers
    );

    pers.rice.currentTheme = mkIf (cfg.colorBackend == "wallust") (
      import ./wallust.nix {
        inherit lib pkgs path;
        default = true;
      }
    );
  };
}
