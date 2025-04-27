{
  lib,
  config,
  ...
}:

{
  options.pers.tailscale.enable = lib.mkEnableOption "tailscale";

  config.services.tailscale = {
    enable = config.pers.tailscale.enable;
    authKeyFile = config.pers.info.getSecretFilePath "tailscale";
  };
}
