{
  lib,
  config,
  settings,
  pkgs,
  ...
}:

{
  options.pers.networkmanager = {
    enable = lib.mkEnableOption "networkmanager";
    openconnect = lib.mkEnableOption "vpn support via openconnect";
  };

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
        plugins = lib.mkIf config.pers.networkmanager.openconnect [ pkgs.networkmanager-openconnect ];
      };
    };
  };
}
