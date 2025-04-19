{ lib, ... }:

with lib;

{
  options.pers.info = {
    terminal = mkOption {
      type = types.nullOr types.str;
      description = "Command to start the terminal";
      default = null;
    };

    terminalCommand = mkOption {
      type = with types; nullOr (functionTo str);
      description = "Function to get the command to start the terminal and execute a command. Takes the command to execute as input.";
      default = null;
    };

    fileManager = mkOption {
      type = types.nullOr types.str;
      description = "Command to start the file manager";
      default = null;
    };

    menu = mkOption {
      type = types.nullOr types.str;
      description = "Command to start the app picker menu";
      default = null;
    };

    music = mkOption {
      type = types.nullOr types.str;
      description = "Command to start the music app";
      default = null;
    };

    getSecretFilePath = mkOption {
      type = with types; nullOr (functionTo (nullOr str));
      description = "Function to get the path to a secret. Should be called with the secret name.";
      default = null;
    };

    loadWallpapers = mkOption {
      type = with types; listOf path;
      description = "List of wallpapers to preload for wallpaper services that support that.";
      default = [ ];
    };

    startupWallpaper = mkOption {
      type = with types; nullOr path;
      description = "First wallpaper to load.";
      default = null;
    };

    setWallpaperCommand = mkOption {
      type = with types; nullOr (functionTo str);
      description = "Function to get the command to change wallpaper. Should be called with the path to the wallpaper.";
      default = null;
    };

    wallpaperPickerCommand = mkOption {
      type = types.nullOr types.str;
      description = "Command to open the wallpaper picker.";
      default = null;
    };

    wallpaperNeedsPreloading = mkEnableOption "wallpaper needs preloading";

    kb_layout = mkOption {
      type = types.nullOr types.str;
      description = "Keyboard layout to use";
      default = null;
    };

    kb_variant = mkOption {
      type = types.nullOr types.str;
      description = "Keyboard variant to use";
      default = null;
    };

    kb_options = mkOption {
      type = types.nullOr types.str;
      description = "Keyboard options to use";
      default = null;
    };

    ifd = mkOption {
      type = types.attrsOf types.anything;
      description = "Import from derivation";
      default = { };
    };

    getIFD = mkOption {
      type = types.functionTo types.anything;
      description = "Function that takes a name as input and returns the output of the IFD";
      default = name: config.pers.info.ifd.${name};
    };
  };
}
