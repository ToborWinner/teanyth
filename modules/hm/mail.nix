{ config, lib, ... }:

{
  options.pers.mail.enable = lib.mkEnableOption "mail";

  config.accounts.email.accounts = lib.mkIf config.pers.mail.enable config.sensitive.mailAccounts;
}
