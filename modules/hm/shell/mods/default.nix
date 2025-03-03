{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.mods.enable = lib.mkEnableOption "mods";

  config = lib.mkIf config.pers.mods.enable {
    home.packages = [ pkgs.mods ];

    home.file = {
      ".config/mods/mods.yml".source = ./mods.yml;
    };

    programs.zsh.shellAliases = {
      m = "OPENAI_API_KEY=`cat ${config.pers.info.getSecretFilePath "groq-api-key"}` mods";
    };
  };
}
