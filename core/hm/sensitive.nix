{ lib, ... }:

with lib;

{
  options.sensitive = {
    mailAccounts = mkOption {
      type = with types; attrsOf (attrsOf anything);
      description = "Email accounts";
    };

    extraAccountSettings = mkOption {
      type = with types; attrsOf anything;
      description = "Attribute sets to be merged with each account.";
    };
  };
}
