{
  lib,
  config,
  ...
}:

{
  options.pers.nushell.enable = lib.mkEnableOption "nushell";

  config = lib.mkIf config.pers.nushell.enable {
    programs.nushell = {
      enable = true;
      shellAliases = {
        info = "info --vi-keys";
      };

      environmentVariables = lib.filterAttrs (
        _: x: !lib.isString x || !lib.hasInfix "\${" x
      ) config.home.sessionVariables;
    };
    programs.carapace.enable = true;
  };
}
