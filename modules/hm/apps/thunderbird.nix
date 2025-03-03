{
  config,
  lib,
  settings,
  ...
}:

{
  options.pers.thunderbird.enable = lib.mkEnableOption "thunderbird";

  config = lib.mkIf config.pers.thunderbird.enable {
    assertions = lib.singleton {
      assertion = config.pers.mail.enable;
      message = "Mail setup must be enabled for thunderbird to be setup.";
    };

    sensitive.extraAccountSettings.thunderbird.enable = true;

    programs.thunderbird = {
      enable = true;
      profiles.${settings.username} = {
        isDefault = true;
      };
    };
  };
}
