{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.shell.enable = lib.mkEnableOption "shell";

  config = lib.mkIf config.pers.shell.enable {
    environment.shells = with pkgs; [
      zsh
      bash
    ];
    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;
  };
}
