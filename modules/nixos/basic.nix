{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.basic.enable = lib.mkEnableOption "basic";

  config = lib.mkIf config.pers.basic.enable {
    environment.systemPackages = with pkgs; [
      wget
      curl
      fastfetch
      tree
      brightnessctl
      vim
      ripgrep
    ];

    environment.variables.EDITOR = "vim";
  };
}
