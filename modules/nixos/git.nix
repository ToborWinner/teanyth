{ lib, config, ... }:

{
  options.pers.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.pers.git.enable {
    programs.git = {
      enable = true;
      config = {
        credential.helper = "";
        init.defaultBranch = "main";
      };
    };
  };
}
