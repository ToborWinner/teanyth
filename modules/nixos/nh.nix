{
  lib,
  config,
  settings,
  ...
}:

{
  options.pers.nh.enable = lib.mkEnableOption "nh";

  config.programs.nh = {
    enable = config.pers.nh.enable;
    flake = settings.dotfilesDir;
  };
}
