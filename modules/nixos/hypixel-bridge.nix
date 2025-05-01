{
  pkgs,
  lib,
  config,
  ...
}:

let
  module =
    { name, ... }:
    {
      options = {
        enable = lib.mkEnableOption "the Hypixel Discord chat bridge" // {
          default = true;
        };
        name = lib.mkOption {
          type = lib.types.str;
          description = "Name used in the systemd unit.";
          default = name;
          defaultText = "<name>";
        };
        configFile = lib.mkOption {
          type = lib.types.str;
          description = "Path to the configuration file.";
        };
      };
    };
in
{
  options.pers.hypixel-bridge = {
    bridges = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule module);
      description = "Attribute set of the Hypixel bridges to run.";
      default = { };
    };

    impermanence = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [ ];
      description = "List of items to keep in impermanence";
    };
  };

  config =
    let
      services = lib.mapAttrs' (
        n: v:
        let
          name = "hypixel-bridge-${v.name}";
        in
        lib.nameValuePair name {
          description = "Hypixel Bridge Bot - ${v.name}";

          after = [ "network-online.target" ];
          requires = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            User = name;
            Group = name;
            Type = "exec";

            LoadCredential = [ "config-file:${v.configFile}" ];

            WorkingDirectory = "/run/${name}";

            RuntimeDirectory = name;
            RuntimeDirectoryMode = "0700";

            StateDirectory = name;
            StateDirectoryMode = "0700";

            ExecStart = lib.getExe pkgs.pers.hypixel-discord-chat-bridge;

            Restart = "always";
            RestartSec = 10;
            RestartSteps = 10;
            RestartMaxDelaySec = 3600;
            KillSignal = "SIGINT";

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

          environment = {
            AUTH_FOLDER = "/var/lib/${name}";
            CONFIG_FILE_PATH = "/run/credentials/${name}.service/config-file";
            NODE_ENV = "production";
          };
        }
      ) config.pers.hypixel-bridge.bridges;

    in
    {
      users.users = builtins.mapAttrs (n: v: {
        description = v.description;
        isSystemUser = true;
        group = n;
      }) services;

      users.groups = builtins.mapAttrs (_: _: { }) services;

      systemd.services = services;

      pers.hypixel-bridge.impermanence = lib.mapAttrsToList (n: _: {
        directory = "/var/lib/${n}";
        user = n;
        group = n;
        mode = "u=rw,g=,o=";
      }) services;
    };
}
