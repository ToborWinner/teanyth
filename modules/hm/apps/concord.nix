{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  concord = inputs.concord.packages.${pkgs.stdenv.buildPlatform.system}.concord;
  makeWrapper =
    name:
    pkgs.writeShellScriptBin name ''
      XDG_CONFIG_HOME="$XDG_CONFIG_HOME/concord/${name}"
      exec ${lib.getExe concord}
    '';
  wrappers =
    builtins.map
      (name: {
        inherit name;
        value = makeWrapper name;
      })
      [
        "con1"
        "con2"
      ];
  discordIconSrc = pkgs.fetchzip {
    # Discord icon
    url = "https://cdn.discordapp.com/assets/content/a736b95923ddbc155e828651c92471292e40727655d770a06cec89c48ba0b41f.zip";
    hash = "sha256-fJWxXI25nsxftSIdaNS/h1/OogKykZOYaFTLu/Mpvgs=";
    stripRoot = false;
  };
  discordIcon = "${discordIconSrc}/Discord_Symbol_Color/Discord-Symbol-Blurple.svg";
in
{
  options.pers.concord.enable = lib.mkEnableOption "concord";

  config = lib.mkIf config.pers.mpv.enable {
    home.packages = builtins.map (x: x.value) wrappers;

    xdg.desktopEntries = builtins.listToAttrs (
      builtins.map (
        { name, value }:
        {
          inherit name;
          value = {
            inherit name;
            genericName = "Discord Client";
            icon = discordIcon;
            exec = config.pers.info.terminalCommand (lib.getExe value);
            terminal = false;
            categories = [
              "Network"
              "InstantMessaging"
            ];
          };
        }
      ) wrappers
    );
  };
}
