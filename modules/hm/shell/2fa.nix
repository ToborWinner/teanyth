{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

{
  options.pers.twofa.enable = mkEnableOption "twofa";

  config = mkIf config.pers.twofa.enable {
    home.packages = singleton (
      pkgs.pers."2fa".override {
        secretCommand = "cat ${config.pers.info.getSecretFilePath "github-2fa"}";
      }
    );
  };
}
