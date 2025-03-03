{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.postgresql.enable = lib.mkEnableOption "postgresql";

  # Development setup
  config.services.postgresql = lib.mkIf config.pers.postgresql.enable {
    enable = true;
    package = pkgs.postgresql_17;
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
}
