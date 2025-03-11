{
  lib,
  config,
  settings,
  sharedInfo,
  ...
}:

with lib;

let
  cfg = config.pers.users;
in
{
  options.pers.users = {
    enable = mkEnableOption "users";
    extraGroups = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "Extra groups to add to the user.";
    };
  };

  config = mkIf cfg.enable {
    users.mutableUsers = false;

    virtualisation.vmVariant.users.users.${settings.username} = {
      hashedPasswordFile = mkVMOverride null;
      password = mkVMOverride "password";
    };

    users.users.${settings.username} = {
      isNormalUser = true;
      description = settings.username;
      extraGroups = [
        (mkIf config.pers.networkmanager.enable "networkmanager")
        "wheel"
      ] ++ cfg.extraGroups;
      hashedPasswordFile = mkIf (config.pers.info.getSecretFilePath != null) (
        config.pers.info.getSecretFilePath "main-user"
      );
      openssh.authorizedKeys.keys = mkIf config.services.openssh.enable [ sharedInfo.sshpub ];
    };

    nix.settings.trusted-users = [ settings.username ];
  };
}
