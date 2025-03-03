{ lib, config, ... }:

{
  options.pers.direnv.enable = lib.mkEnableOption "direnv";

  config = lib.mkIf config.pers.direnv.enable {
    assertions = lib.singleton {
      assertion = config.pers.zsh.enable;
      message = "At least one direnv-supported shell must be enabled for direnv to be enabled.";
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = config.pers.zsh.enable;
      nix-direnv.enable = true;
      config = {
        hide_env_diff = true;
      };
    };
  };
}
