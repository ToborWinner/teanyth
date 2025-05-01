{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.pers.postgresql;
in
{
  options.pers.postgresql = {
    enable = lib.mkEnableOption "postgresql";
    development = lib.mkEnableOption "postgresql only for development";
    databases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of databases to create. Users with peer authentication will also be setup.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.postgresql = {
        enable = true;
        package = pkgs.postgresql_17;
        ensureUsers = map (name: {
          inherit name;
          ensureDBOwnership = true;
        }) cfg.databases;
        ensureDatabases = cfg.databases;
      };

      systemd.services.postgresql.preStart = lib.mkBefore ''
        if ! test -e ${config.services.postgresql.dataDir}/PG_VERSION; then
          echo "Setting up directory with NOCOW."
          ${pkgs.e2fsprogs}/bin/chattr +C ${config.services.postgresql.dataDir} || true
        fi
      '';
    })
    # Old development setup, might remove in a while
    (lib.mkIf (cfg.development && cfg.development) {
      services.postgresql = {
        authentication = pkgs.lib.mkOverride 10 ''
          #type database DBuser origin-address auth-method
          local all       all     trust
          # ipv4
          host  all      all     127.0.0.1/32   trust
          # ipv6
          host all       all     ::1/128        trust
        '';
        initialScript = pkgs.writeText "backend-initScript" ''
          CREATE ROLE devuser WITH LOGIN PASSWORD 'devpassword' CREATEDB;
          CREATE DATABASE devtest;
          GRANT ALL PRIVILEGES ON DATABASE devtest TO devuser;
        '';
      };
    })
  ];
}
