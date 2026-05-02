{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.pers.awww;
in
{
  options.pers.awww = {
    enable = mkEnableOption "awww";
    package = mkPackageOption pkgs "awww" { };
    transitionArguments = mkOption {
      type = with types; attrsOf str;
      description = "Options to pass to the awww img command to change the transition";
      default = {
        transition-type = "grow";
      };
    };
  };

  config = mkIf config.pers.awww.enable {
    assertions = [
      {
        assertion = config.pers.wayland.enable;
        message = "Wayland support must be enabled for awww to be enabled.";
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
          if ${config.systemd.user.systemctlPath} --user is-active --quiet awww.service; then
            ${cfg.package}/bin/awww img ${transitionArgs} ${escapeShellArg wp}
          fi
        '';
      wallpaperNeedsPreloading = false;
    };

    systemd.user.services.awww = {
      Install = {
        WantedBy = [ config.wayland.systemd.target ];
      };

      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "awww";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
      };

      Service = {
        ExecStart = "${cfg.package}/bin/awww-daemon";
        ExecStartPost = mkIf (
          config.pers.info.startupWallpaper != null
        ) "${cfg.package}/bin/awww img -t none ${escapeShellArg config.pers.info.startupWallpaper}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
