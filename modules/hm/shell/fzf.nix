{ lib, config, ... }:

{
  options.pers.fzf.enable = lib.mkEnableOption "fzf";

  config = lib.mkIf config.pers.fzf.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = config.pers.zsh.enable;
    };
  };
}
