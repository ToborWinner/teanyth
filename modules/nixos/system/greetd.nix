{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.greetd = {
    enable = lib.mkEnableOption "greetd";
    startCommand = lib.mkOption {
      type = lib.types.str;
      description = "The command to start the window manager / DE";
    };
  };

  config = lib.mkIf config.pers.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${lib.escapeShellArg config.pers.greetd.startCommand}";
          user = "greeter";
        };
      };
    };
  };
}
