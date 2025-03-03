{ lib, config, ... }:

{
  options.pers.ncmpcpp.enable = lib.mkEnableOption "ncmpcpp";

  config = lib.mkIf config.pers.ncmpcpp.enable {
    assertions = lib.singleton {
      assertion = config.pers.mpd.enable;
      message = "Mpd must be enabled for ncmpcpp (an mpd client) to be enabled";
    };

    pers.info.music = config.pers.info.terminalCommand (lib.getExe config.programs.ncmpcpp.package);

    programs.ncmpcpp.enable = true;
  };
}
