{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.guildbot.enable = lib.mkEnableOption "guildbot";

  config = lib.mkIf config.pers.guildbot.enable {
    pers.postgresql = {
      enable = true;
      databases = [ "guildbot" ];
    };

    users.users.guildbot = {
      description = "Guild Discord Bot";
      isSystemUser = true;
      group = "guildbot";
    };

    users.groups.guildbot = { };

    systemd.services.guildbot = {
      description = "Guild Discord Bot";

      after = [
        "network-online.target"
        "postgresql.service"
      ];
      requires = [
        "network-online.target"
        "postgresql.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "guildbot";
        Group = "guildbot";
        Type = "exec";

        LoadCredential = [
          "config.json:${config.pers.info.getSecretFilePath "guildbot-config"}"
        ];

        ExecStart = lib.getExe pkgs.pers.guildbot;

        Restart = "always";
        RestartSec = 10;
        RestartSteps = 10;
        RestartMaxDelaySec = 3600;

        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = "strict";
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
      };
    };
  };
}
