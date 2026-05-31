{ lib, config, ... }:

{
  options.pers.kitty.enable = lib.mkEnableOption "kitty";

  config = lib.mkIf config.pers.kitty.enable {
    pers.info.terminal = "kitty";
    pers.info.terminalCommand = cmd: "${lib.getExe config.programs.kitty.package} ${cmd}";

    programs.kitty = {
      enable = true;
    };
  };
}
