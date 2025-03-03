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
  ];

  modules = args.lib.pers.getFolderModules {
    folder = ./.;
    ignoreDefault = true;
  };
}
