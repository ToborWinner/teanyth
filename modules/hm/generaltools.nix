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
      (pkgs.python3.withPackages (
        pythonPackages: with pythonPackages; [
          pwntools
        ]
      ))
      gef
    ];

    xdg.configFile."gdb/gdbinit".text = ''
      add-auto-load-safe-path /home/tobor/Documents/Projects/linux/scripts
    '';

    # TODO: When pwntools updates, switch gdb_binary to gef instead of specifying the gdbinit
    xdg.configFile."pwn.conf".text = ''
      [context]
      terminal = ['tmux', 'splitw', '-h']
      gdbinit = "${pkgs.gef}/share/gef/gef.py"
    '';
  };
}
