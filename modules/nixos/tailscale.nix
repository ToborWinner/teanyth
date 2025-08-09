{ lib, config, ... }:

{
  options.pers.tailscale.enable = lib.mkEnableOption "tailscale";

  config = lib.mkIf config.pers.tailscale.enable {
    services.tailscale = {
      enable = true;
      authKeyFile = config.pers.info.getSecretFilePath "tailscale";
      extraDaemonFlags = [
        "--no-logs-no-support"
      ];
    };
  };
}
