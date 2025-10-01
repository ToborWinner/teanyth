args:
args.lib.pers.mkRice args {
  name = "newconfig";
  wm = "hyprland";

  themesFromWallpapers = true;
  wallpapers = [
    {
      name = "lake";
      path = ../../wallpapers/lake-sunset.png;
    }
    {
      name = "trees";
      path = ../../wallpapers/trees.jpg;
    }
    {
      # Generated with nix build --impure --expr '(builtins.getFlake "github:lunik1/nix-wallpaper").packages.${builtins.currentSystem}.default.override { preset = "catppuccin-mocha-rainbow"; width = 2560; height = 1664; logoSize = 35; }'
      name = "mocha-minimal";
      path = ../../wallpapers/minimal-nixos.png;

      colors =
        let
          hex = {
            cursor = "#f38ba8"; # red
            background = "#1e1e2e"; # base
            foreground = "#cdd6f4"; # text
            color0 = "#1e1e2e"; # base
            color1 = "#181825"; # mantle
            color2 = "#313244"; # surface0
            color3 = "#45475a"; # surface1
            color4 = "#585b70"; # surface2
            color5 = "#cdd6f4"; # text
            color6 = "#f5e0dc"; # rosewater
            color7 = "#b4befe"; # lavender
            color8 = "#f38ba8"; # red
            color9 = "#fab387"; # peach
            color10 = "#f9e2af"; # yellow
            color11 = "#a6e3a1"; # green
            color12 = "#94e2d5"; # teal
            color13 = "#89b4fa"; # blue
            color14 = "#cba6f7"; # mauve
            color15 = "#f2cdcd"; # flamingo
          };
          hexS = builtins.mapAttrs (_: value: args.lib.removePrefix "#" value) hex;
          num = builtins.mapAttrs (_: value: args.lib.fromHexString value) hexS;
        in
        {
          inherit hex hexS num;
        };
    }
  ];

  modules = args.lib.pers.getFolderModules {
    folder = ./.;
    ignoreDefault = true;
  };
}
