{ lib, config, ... }:

{
  options.pers.alacritty.enable = lib.mkEnableOption "alacritty";

  config = lib.mkIf config.pers.alacritty.enable {
    pers.info.terminal = "alacritty";
    pers.info.terminalCommand =
      cmd: "${lib.getExe config.programs.alacritty.package} --command ${lib.escapeShellArg cmd}";

    programs.alacritty = {
      enable = true;
    };
  };
}
