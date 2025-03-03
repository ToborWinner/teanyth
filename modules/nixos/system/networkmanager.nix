{
  lib,
  config,
  settings,
  ...
}:

{
  options.pers.networkmanager.enable = lib.mkEnableOption "networkmanager";

  config = lib.mkIf config.pers.networkmanager.enable {
    networking = {
      hostName = settings.hostname;
      wireless.iwd = {
        enable = true;
        settings.General.EnableNetworkConfiguration = true;
      };
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };
  };
}
