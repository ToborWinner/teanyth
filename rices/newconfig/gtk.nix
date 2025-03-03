{
  lib,
  pkgs,
  config,
  ...
}:

{
  gtk = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font Mono";
    font.package = pkgs.nerd-fonts.jetbrains-mono;

    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };
  };

  xdg.configFile =
    let
      css = lib.pers.gtkCSSFromWallust config.pers.rice.currentTheme.hexS;
    in
    {
      "gtk-3.0/gtk.css".text = css;
      "gtk-4.0/gtk.css".text = css;
    };

  home.pointerCursor.gtk.enable = true;
}
