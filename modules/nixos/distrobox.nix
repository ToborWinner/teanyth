{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.pers.distrobox.enable = lib.mkEnableOption "distrobox";

  config = lib.mkIf config.pers.distrobox.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    environment.systemPackages = [ pkgs.distrobox ];
  };
}
