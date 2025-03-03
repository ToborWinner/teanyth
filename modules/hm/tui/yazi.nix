{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.yazi.enable = lib.mkEnableOption "yazi";

  config = lib.mkIf config.pers.yazi.enable {
    pers.info.fileManager = config.pers.info.terminalCommand (lib.getExe config.programs.yazi.package);

    nix.settings = {
      extra-substituters = [ "https://yazi.cachix.org" ];
      extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
    };

    home.packages = with pkgs; [ ueberzugpp ];

    programs.yazi = {
      enable = true;
      enableZshIntegration = config.pers.zsh.enable;
      settings = {
        manager = {
          show_hidden = true;
        };
      };
    };
  };
}
