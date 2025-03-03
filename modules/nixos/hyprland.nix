{ lib, config, ... }:

{
  options.pers.hyprland.enable = lib.mkEnableOption "hyprland";

  config = lib.mkIf config.pers.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    pers = {
      home-manager.imports = lib.singleton { pers.hyprland.enable = lib.mkDefault true; };
      wayland.enable = true;
    };
  };
}
