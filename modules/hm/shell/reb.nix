{
  lib,
  config,
  pkgs,
  settings,
  ...
}:

with lib;

{
  options.pers.reb.enable = mkEnableOption "reb";

  config = mkIf config.pers.reb.enable {
    assertions = singleton {
      assertion = config.pers.git.enable;
      message = "Git must be configured for the reb script to be enabled";
    };

    home.packages = singleton (pkgs.pers.reb.override { inherit (settings) dotfilesDir; });
  };
}
