{ lib, config, ... }:

{
  options.pers.starship.enable = lib.mkEnableOption "starship";

  config = lib.mkIf config.pers.starship.enable {
    assertions = lib.singleton {
      assertion = config.pers.zsh.enable;
      message = "At least one starship-supported shell must be enabled for starship to be enabled";
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = config.pers.zsh.enable;
      settings = {
        add_newline = false;
      };
    };
  };
}
