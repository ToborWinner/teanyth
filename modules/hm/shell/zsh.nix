{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.zsh.enable = lib.mkEnableOption "zsh";

  config = lib.mkIf config.pers.zsh.enable {
    home.sessionVariables = {
      ZVM_CURSOR_STYLE_ENABLED = "false"; # Zsh plugin
    };

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      plugins = [
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
      initExtra = ''
        unsetopt HIST_SAVE_BY_COPY
      '';
    };
  };
}
