{ lib, config, ... }:

{
  options.pers.openssh.enable = lib.mkEnableOption "openssh";

  config = lib.mkMerge [
    (lib.mkIf config.pers.openssh.enable {
      services.openssh = {
        enable = true;
        # require public key authentication for better security
        settings.PasswordAuthentication = false;
        settings.KbdInteractiveAuthentication = false;
        # Prevent root login via ssh by default
        settings.PermitRootLogin = lib.mkDefault "no";
      };
    })
    (lib.mkIf (config.pers.openssh.enable && config.pers.info.getSecretFilePath != null) {
      services.openssh.hostKeys = [ ];
    })
  ];
}
