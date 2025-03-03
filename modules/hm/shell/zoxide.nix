{ lib, config, ... }:

{
  options.pers.zoxide.enable = lib.mkEnableOption "zoxide";

  config = lib.mkIf config.pers.zoxide.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = config.pers.zsh.enable;
    };
  };
}
