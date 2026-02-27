{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.pers.hyprland.enable = lib.mkEnableOption "hyprland";

  config = lib.mkIf config.pers.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    environment.systemPackages = [ pkgs.hyprpolkitagent ];

    systemd.packages = [ pkgs.hyprpolkitagent ];
    # For some reason the WantedBy of the package file doesn't work, so we need this:
    systemd.user.services.hyprpolkitagent.wantedBy = [ "graphical-session.target" ];

    pers.home-manager.imports = lib.singleton { pers.hyprland.enable = lib.mkDefault true; };
  };
}
