{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.pers.tex.enable = lib.mkEnableOption "latex";

  config.home.packages = lib.mkIf config.pers.tex.enable [
    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-small
        latexmk
        catppuccinpalette
        pgfopts
        csquotes
        doublestroke
        pgfplots
        ;
    })
  ];
}
