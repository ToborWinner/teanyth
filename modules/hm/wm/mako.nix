{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.mako.enable = lib.mkEnableOption "mako";

  config = lib.mkIf config.pers.mako.enable {
    home.packages = [ pkgs.libnotify ];

    services.mako = {
      enable = true;
      settings = {
        default-timeout = 3000;
        icons = true;
      };
    };
  };
}
