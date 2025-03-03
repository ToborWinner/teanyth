{
  lib,
  pkgs,
  path,
  default ? false,
}:

# TODO: Add somewhere so that nix-collect-garbage doesn't clear it.

with lib;

let
  generatedJSON = pkgs.runCommand "wallust.json" { } ''
    export XDG_CACHE_HOME=$(pwd)
    echo "${escapeShellArg path}"
    ${pkgs.wallust}/bin/wallust run -Ns ${escapeShellArg "${path}"}
    mv wallust/$(ls -1 wallust) $out
  '';
  hex = importJSON generatedJSON;
  hexS = mapAttrs (_: value: removePrefix "#" value) hex;
  num = mapAttrs (_: value: fromHexString value) hexS;

  defNum = {
    foreground = 0;
    background = 0;
  } // (genAttrs (genList (i: "color${toString i}") 16) (_: 0));
  defHex = mapAttrs (_: v: "#${toString v}") defNum;
  defHexS = mapAttrs (_: v: toString v) defNum;
in
if default then
  {
    hex = mkDefault defHex;
    hexS = mkDefault defHexS;
    num = mkDefault defNum;
  }
else
  { inherit hex hexS num; }
