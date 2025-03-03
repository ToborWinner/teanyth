{ lib, config, ... }:

{
  options.pers.gh.enable = lib.mkEnableOption "gh";

  config.programs.gh = lib.mkIf config.pers.gh.enable {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
