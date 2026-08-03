{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.pers.wl-kbptr = {
    enable = lib.mkEnableOption "wl-kbptr";
    package = lib.mkOption {
      type = lib.types.package;
      description = "The package to install for wl-kbptr";
      default = pkgs.wl-kbptr.overrideAttrs (
        final: prev: {
          # Remove opencv dependency cause we don't use floating mode
          buildInputs = builtins.filter (pkg: pkg.pname != "opencv") prev.buildInputs;
          mesonFlags = [ "-Dopencv=disabled" ];
        }
      );
    };
  };

  config = lib.mkIf config.pers.wl-kbptr.enable {
    home.packages = [ config.pers.wl-kbptr.package ];
  };
}
