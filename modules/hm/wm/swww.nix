{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.pers.swww;
in
{
  options.pers.swww = {
    enable = mkEnableOption "swww";
    package = mkPackageOption pkgs "swww" { };
    transitionArguments = mkOption {
      type = with types; attrsOf str;
      description = "Options to pass to the swww img command to change the transition";
      default = {
        transition-type = "grow";
      };
    };
  };

  config = mkIf config.pers.swww.enable {
    assertions = [
      {
        assertion = config.pers.wayland.enable;
        message = "Wayland support must be enabled for swww to be enabled.";
      }
    ];

    pers.info = {
      setWallpaperCommand =
        wp:
        let
          transitionArgs = concatMapAttrsStringSep " " (
            n: v: "--${escapeShellArg n} ${escapeShellArg v}"
          ) cfg.transitionArguments;
        in
        ''
          if ${config.systemd.user.systemctlPath} --user is-active --quiet swww.service; then
            ${cfg.package}/bin/swww img ${transitionArgs} ${escapeShellArg wp}
          fi
        '';
      wallpaperNeedsPreloading = false;
    };

    systemd.user.services.swww = {
      Install = {
        WantedBy = [ config.wayland.systemd.target ];
      };

      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "swww";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };

      Service = {
        ExecStart = "${cfg.package}/bin/swww-daemon";
        ExecStartPost = mkIf (
          config.pers.info.startupWallpaper != null
        ) "${cfg.package}/bin/swww img -t none ${escapeShellArg config.pers.info.startupWallpaper}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
