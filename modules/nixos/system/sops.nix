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

  options.pers.sops = {
    enable = mkEnableOption "sops";
    accounts = mkEnableOption "accounts secrets";
    user = mkEnableOption "main user password";
    extraSecrets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of additional secrets.";
    };
  };

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

      pers.info.getSecretFilePath = secret: config.sops.secrets.${secret}.path or null;
      pers.home-manager.imports = singleton {
        pers.info.getSecretFilePath = config.pers.info.getSecretFilePath;
      };

      sops = {
        defaultSopsFile = inputs.sensitive + "/secrets/hosts/${settings.hostname}.yaml";
        defaultSopsFormat = "yaml";

        age.keyFile = "/persist/secrets/hosts/${settings.hostname}";

        secrets = mkMerge [
          (mkIf config.pers.openssh.enable {
            ssh-hostkey.path = "/etc/ssh/ssh_host_ed25519_key";
          })
          (mkIf cfg.accounts (
            let
              allowUser = {
                owner = config.users.users.${settings.username}.name;
                inherit (config.users.users.${settings.username}) group;
                sopsFile = inputs.sensitive + "/secrets/accounts.yaml";
              };
            in
            {
              icloud-mail = allowUser;
              outlook-mail = allowUser;
              groq-api-key = allowUser;
              github-2fa = allowUser;
            }
          ))
          (mkIf cfg.user {
            main-user.neededForUsers = true;
          })
          (mkIf config.pers.jolly.enable {
            mongodb-root-password = { };
            mongodb-user-password = { };
            redis-password = { };
            jollybot-env-file = { };
            jollydashboard-env-file = { };
          })
          (mkIf (config.pers.jolly.enable && config.pers.jolly.nginx) {
            ssl-certificate = { };
            ssl-certificate-key = { };
            ssl-client-certificate = { };
          })
          (builtins.listToAttrs (map (n: lib.nameValuePair n { }) cfg.extraSecrets))
        ];
      };
    })
  ];
}
