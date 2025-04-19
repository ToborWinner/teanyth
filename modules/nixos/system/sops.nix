{
  lib,
  config,
  inputs,
  settings,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.pers.sops;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.pers.sops.enable = mkEnableOption "sops";

  config = mkMerge [
    {
      # If sops was enabled, then all secrets would simply be "password"
      virtualisation.vmVariant.pers.sops.enable = mkVMOverride false;
    }
    (mkIf cfg.enable {
      virtualisation.vmVariant.pers = {
        # Note that settings in here are set in vmVariant even though sops is disabled in vmVariant.
        # That's because they're not set in vmVariant, but rather from the main config, where sops is enabled.
        info.getSecretFilePath = mkVMOverride (secret: toString (pkgs.writeText "vm-password" "password"));
        # Sops is disabled in vmVariant, so this needs to be set again
        home-manager.imports = singleton {
          pers.info.getSecretFilePath = config.pers.info.getSecretFilePath;
        };
      };

      pers.info.getSecretFilePath = secret: config.sops.secrets.${secret}.path;
      pers.home-manager.imports = singleton {
        pers.info.getSecretFilePath = config.pers.info.getSecretFilePath;
      };

      sops = {
        defaultSopsFile = inputs.sensitive + "/secrets/hosts/${settings.hostname}.yaml";
        defaultSopsFormat = "yaml";

        age.keyFile = "/persist/secrets/hosts/${settings.hostname}";

        secrets = {
          ssh-hostkey = mkIf config.pers.openssh.enable { path = "/etc/ssh/ssh_host_ed25519_key"; };
        };
      };
    })
  ];
}
