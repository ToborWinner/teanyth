{ lib, config, ... }:

{
  options.pers.pipewire.enable = lib.mkEnableOption "pipewire";

  config = lib.mkIf config.pers.pipewire.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    security.rtkit.enable = true;
  };
}
