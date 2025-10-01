{
  config,
  pkgs,
  ...
}:

{
  programs.rofi = {
    theme =
      (pkgs.writeTextFile {
        text =
          (
            if config.pers.themeName == "mocha-minimal" then
              ''
                * {
                    background:     #1E1D2FFF;
                    background-alt: #282839FF;
                    foreground:     #D9E0EEFF;
                    selected:       #7AA2F7FF;
                    active:         #ABE9B3FF;
                    urgent:         #F28FADFF;
                }
              ''
            else
              with config.pers.rice.currentTheme.hex;
              ''
                * {
                    background:     ${background}FF;
                    background-alt: ${color2}FF;
                    foreground:     ${foreground}FF;
                    selected:       ${color3}FF;
                    active:         #ABE9B3FF;
                    urgent:         #F28FADFF;
                }
              ''
          )
          + builtins.readFile ./theme.rasi;
        name = "newconfig.rasi";
      }).outPath;
  };
}
