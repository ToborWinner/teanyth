{
  lib,
  config,
  ...
}:

{
  options.pers.ghidra.enable = lib.mkEnableOption "ghidra";

  config = lib.mkIf config.pers.ghidra.enable {
    programs.ghidra = {
      enable = true;
      gdb = true;
    };
  };
}
