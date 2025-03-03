{
  lib,
  config,
  inputs,
  settings,
  ...
}:

with lib;

let
  cfg = config.pers.sops;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.pers.sops.enable = mkEnableOption "sops";

  config = mkIf cfg.enable {
    pers.info.getSecretFilePath = secret: config.sops.secrets.${secret}.path;
    pers.home-manager.imports = singleton {
      pers.info.getSecretFilePath = secret: config.sops.secrets.${secret}.path;
    };

    sops = {
      defaultSopsFile = inputs.sensitive + "/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";

      age.keyFile = "/persist/secrets/sops.txt";

      secrets =
        let
          allowUser = {
            owner = config.users.users.${settings.username}.name;
            inherit (config.users.users.${settings.username}) group;
          };
        in
        {
          main-user = {
            neededForUsers = true;
          };
          icloud-mail = allowUser;
          outlook-mail = allowUser;
          groq-api-key = allowUser;
          github-2fa = allowUser;
        };
    };
  };
}
