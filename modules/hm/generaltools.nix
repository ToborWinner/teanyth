{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.pers.generaltools.enable = lib.mkEnableOption "general tools for quick access without a shell";

  config = lib.mkIf config.pers.generaltools.enable {
    home.packages = with pkgs; [
      gcc
      gnumake
      file
      unzip
      binwalk
      gdb
      rustc
      cargo
      nodejs
      python3
      gef
    ];

    home.file.".config/gdb/gdbinit".text = ''
      add-auto-load-safe-path /home/tobor/Documents/Projects/linux/scripts
    '';
  };
}
