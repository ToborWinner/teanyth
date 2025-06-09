{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  # Can't import the module the flake provides because it adds packages with a toggle option

  options.pers.nix-index-database.enable = lib.mkEnableOption "nix-index-database";

  config = lib.mkIf config.pers.nix-index-database.enable {
    programs.nix-index = {
      enable = true;
      enableZshIntegration = config.pers.zsh.enable;
      package = inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-db;
    };
    programs.command-not-found.enable = false;
    home.packages = [
      inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.comma-with-db
    ];

    home.file."${config.xdg.cacheHome}/nix-index/files".source =
      inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-database;
  };
}
