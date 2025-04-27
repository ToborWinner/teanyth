{
  lib,
  config,
  pkgs,
  inputs,
}:

let
  cfg = config.pers.jolly;
in
{
  options.pers.jolly = {
    enable = lib.mkEnableOption "Jolly Discord bot and dashboard";
    nginx = lib.mkEnableOption "nginx for Jolly dashboard";
    openFirewall = lib.mkEnableOption "opening the firewall for Jolly dashboard";
    disableUnits = lib.mkEnableOption "to disable the bot and dashboard units (which is useful to load a database backup or something of the sort)";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.all (secret: config.pers.info.getSecretFilePath secret != null) [
          "mongodb-root-password"
          "mongodb-user-password"
          "redis-password"
          "jollybot-env-file"
          "jollydashboard-env-file"
        ];
        message = "For Jolly to be enabled all the required secrets must be available.";
      }
      {
        assertion =
          cfg.nginx
          -> (builtins.all (secret: config.pers.info.getSecretFilePath secret != null) [
            "ssl-certificate"
            "ssl-certificate-key"
            "ssl-client-certificate"
          ]);
        message = "For Jolly with nginx to be enabled all the required secrets must be available.";
      }
    ];

    # ---------- MONGODB ----------

    services.mongodb = {
      package = pkgs.mongodb-ce;
      enable = true;
      enableAuth = true;
      initialRootPasswordFile = config.pers.info.getSecretFilePath "mongodb-root-password";
      dbpath = "/var/db/mongodb/db";
    };

    systemd.services.mongodb = {
      preStart = lib.mkBefore ''
        rm ${config.services.mongodb.dbpath}/mongod.lock || true
        if ! test -e ${config.services.mongodb.dbpath}; then
            install -d -m0700 -o ${config.services.mongodb.user} ${config.services.mongodb.dbpath}
            ${pkgs.e2fsprogs}/bin/chattr +C ${config.services.mongodb.dbpath} || true
            touch ${config.services.mongodb.dbpath}/.first_startup
        fi
      '';
      postStart = lib.mkForce "";

      serviceConfig.LimitNOFILE = 64000;
      environment.GLIBC_TUNABLES = "glibc.pthread.rseq=0";
    };

    # This is preferred to services.mongodb.initialScript because it allows for requiring that this script has been ran before starting another systemd unit.
    systemd.services.mongodb-setup = {
      description = "Sets up the user for MongoDB";

      wantedBy = [ "multi-user.target" ];
      after = [ "mongodb.service" ];
      requires = [ "mongodb.service" ];

      unitConfig = {
        ConditionPathExists = "${config.services.mongodb.dbpath}/.first_startup";
      };

      serviceConfig = {
        User = config.services.mongodb.user;
        Group = config.services.mongodb.user;
        Type = "oneshot";

        LoadCredential = [
          "root-password:${config.services.mongodb.initialRootPasswordFile}"
          "user-password:${config.pers.info.getSecretFilePath "mongodb-user-password"}"
        ];
      };

      script =
        let
          username = "jolly";
          dbName = "jollydb";
        in
        ''
          initialRootPassword=$(</run/credentials/mongodb-setup.service/root-password)
          userPassword=$(</run/credentials/mongodb-setup.service/user-password)
          ${lib.getExe config.services.mongodb.mongoshPackage} -u root -p "$initialRootPassword" admin <<EOF
            const password = "$userPassword";

            if (!password) {
              print("Password not present.");
              quit(1);
            }

            const userExists = db.system.users.findOne({ user: "${username}" });

            if (userExists) {
              print("User '${username}' already exists. No changes made.");
            } else {
              print("Creating user '${username}' with access to database '${dbName}'...");

              const targetDB = db.getSiblingDB("${dbName}");
              targetDB.createUser({
                user: "${username}",
                pwd: password,
                roles: [
                  {
                    role: "readWrite",
                    db: "${dbName}",
                  },
                  {
                    role: "dbAdmin",
                    db: "${dbName}",
                  },
                ],
              });

              print("User '${username}' created successfully.");
            }
          EOF
          rm -f "${config.services.mongodb.dbpath}/.first_startup"
        '';
    };

    # ---------- REDIS ----------

    services.redis.servers."" = {
      enable = true;
      save = [
        [
          20
          1
        ]
      ];
      databases = 1;
      requirePassFile = config.pers.info.getSecretFilePath "redis-password";
      settings.dir = lib.mkForce "/var/lib/redis/db/dump";
    };

    systemd.services.redis-setup = {
      description = "Sets up the directory for Redis";

      wantedBy = [ "redis.service" ];
      before = [ "redis.service" ];

      unitConfig = {
        ConditionPathExists = "!/var/lib/redis/db/dump";
      };

      serviceConfig.Type = "oneshot";

      script = ''
        mkdir -p /var/lib/redis/db/dump
        chown redis:redis /var/lib/redis/db/dump
        chmod 0700 /var/lib/redis
        ${pkgs.e2fsprogs}/bin/chattr +C /var/lib/redis/db/dump || true
      '';
    };

    # ---------- BOT ----------

    users.users.jollybot = {
      description = "Jolly Discord Bot";
      isSystemUser = true;
      group = "jollybot";
    };

    users.groups.jollybot = { };

    systemd.services.jollybot = {
      description = "Jolly Discord Bot";

      after = [
        "network-online.target"
        "mongodb.service"
        "mongodb-setup.service"
      ];
      wants = [ "mongodb-setup.service" ];
      requires = [
        "network-online.target"
        "mongodb.service"
      ];
      wantedBy = lib.mkIf (!cfg.disableUnits) [ "multi-user.target" ];

      serviceConfig = {
        User = "jollybot";
        Group = "jollybot";
        Type = "exec";

        EnvironmentFile = config.pers.info.getSecretFilePath "jollybot-env-file";

        ExecStart = lib.getExe (
          pkgs.pers.jollybot.override {
            jollybotsrc = inputs.jollybot;
          }
        );

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

    # ---------- WEBSITE ----------

    users.users.jollydashboard = {
      description = "Jolly Website";
      isSystemUser = true;
      group = "jollydashboard";
    };

    users.groups.jollydashboard = { };

    # TODO: As the docs say, we could also use systemd sockets to only turn this on when a request comes.
    systemd.services.jollydashboard = {
      description = "Jolly Website";

      after = [
        "network-online.target"
        "mongodb.service"
        "mongodb-setup.service"
        "redis.service"
      ];
      wants = [ "mongodb-setup.service" ];
      requires = [
        "network-online.target"
        "mongodb.service"
        "redis.service"
      ];
      wantedBy = lib.mkIf (!cfg.disableUnits) [ "multi-user.target" ];

      serviceConfig = {
        User = "jollydashboard";
        Group = "jollydashboard";
        Type = "exec";

        EnvironmentFile = config.pers.info.getSecretFilePath "jollydashboard-env-file";

        ExecStart = lib.getExe (
          pkgs.pers.jollydashboard.override {
            jollydashboardsrc = inputs.jollydashboard;
          }
        );

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

    # ---------- NGINX ----------

    services.nginx = lib.mkIf cfg.nginx {
      enable = !cfg.disableUnits;
      virtualHosts."jollydisc.com" = {
        forceSSL = true;
        http3 = false;
        locations."/".proxyPass = "http://localhost:3000";
        serverAliases = "www.jollydisc.com";
        sslCertificate = "/run/credentials/nginx.service/ssl-certificate";
        sslCertificateKey = "/run/credentials/nginx.service/ssl-certificate-key";
        extraConfig = ''
          ssl_client_certificate /run/credentials/nginx.service/ssl-client-certificate;
          ssl_verify_client on;
        '';
      };
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedZstdSettings = true;
      recommendedProxySettings = true;
    };

    systemd.services.nginx.serviceConfig.LoadCredential = lib.mkIf cfg.nginx [
      "ssl-certificate:${config.pers.info.getSecretFilePath "ssl-certificate"}"
      "ssl-certificate-key:${config.pers.info.getSecretFilePath "ssl-certificate-key"}"
      "ssl-client-certificate:${config.pers.info.getSecretFilePath "ssl-client-certificate"}"
    ];

    networking.allowedTCPPorts = lib.mkIf (cfg.nginx && cfg.openFirewall) [
      80
      443
    ];
  };
}
