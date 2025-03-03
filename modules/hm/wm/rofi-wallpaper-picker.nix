{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.pers.rofi-wallpaper-picker;
  array = concatImapStringsSep "\n" (
    i: v: "wallpapers[${toString (i - 1)}]=${escapeShellArg v.command}"
  ) cfg.wallpapers;
  forRofi = concatImapStrings (i: v: "${toString (i - 1)}\\0icon\\x1f${v.path}\\n") cfg.wallpapers;
  picker = pkgs.writeShellScriptBin "rofi-wallpaper-picker" ''
    answer=$(echo -en ${escapeShellArg forRofi} | ${config.programs.rofi.package}/bin/rofi -dmenu -show-icons -no-config)

    if [[ -z $answer ]] ; then
      exit 0
    fi

    ${array}

    ''${wallpapers[$answer]}
  '';
in
{
  options.pers.rofi-wallpaper-picker = {
    enable = mkEnableOption "rofi-wallpaper-picker";
    wallpapers = mkOption {
      type =
        with types;
        listOf (
          types.submodule {
            options = {
              command = mkOption {
                type = str;
                description = "The command to execute for this wallpaper";
              };

              path = mkOption {
                type = pathInStore;
                description = "The path of the wallpaper.";
              };
            };
          }
        );
      description = "List of wallpapers and commands to use";
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.pers.rofi.enable;
        message = "Rofi must be enabled for rofi-wallpaper-picker to be enabled.";
      }
      {
        assertion = length cfg.wallpapers != 0;
        message = "You have enabled config.pers.rofi-wallpaper-picker without providing any wallpapers.";
      }
    ];

    home.packages = singleton picker;

    pers.info.wallpaperPickerCommand = getExe picker;
  };
}
