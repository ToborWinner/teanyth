{ lib, config, ... }:

{
  options.pers.tty.enable = lib.mkEnableOption "tty";

  config = lib.mkIf config.pers.tty.enable {
    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true; # use xkb.options in tty.
    };

    # Configure keyboard layouts
    services.xserver.xkb.layout = config.pers.info.kb_layout;
    services.xserver.xkb.variant = config.pers.info.kb_variant;
    services.xserver.xkb.options = config.pers.info.kb_options;
  };
}
