{
  lib,
  config,
  osConfig,
  ...
}:

{
  options.pers.waybar.enable = lib.mkEnableOption "waybar";

  config = lib.mkIf config.pers.waybar.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };

    # A reload, last I tested, seemed not to fully reload the style. The result ended up being a mix of the previous and next style.
    systemd.user.services.waybar.Unit.X-Restart-Triggers =
      lib.optional (
        config.programs.waybar.settings != [ ]
      ) "${config.xdg.configFile."waybar/config".source}"
      ++ lib.optional (
        config.programs.waybar.style != null
      ) "${config.xdg.configFile."waybar/style.css".source}";

    xdg.configFile."waybar/config".onChange =
      lib.mkForce "${osConfig.systemd.package}/bin/systemctl --user restart waybar || true";
    xdg.configFile."waybar/style.css".onChange =
      lib.mkForce "${osConfig.systemd.package}/bin/systemctl --user restart waybar || true";
  };
}
