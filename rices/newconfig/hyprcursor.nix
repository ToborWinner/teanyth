{ pkgs, ... }:

{
  home.packages = [ pkgs.hyprcursor ];

  home.pointerCursor = {
    name = "catppuccin-mocha-red-cursors";
    package = pkgs.catppuccin-cursors.mochaRed;
    size = 64;

    hyprcursor.enable = true;
  };
}
