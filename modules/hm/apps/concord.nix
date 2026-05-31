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
        "con3"
      ];
  discordIconSrc = pkgs.fetchzip {
    # Discord icon
    url = "https://cdn.discordapp.com/assets/content/a736b95923ddbc155e828651c92471292e40727655d770a06cec89c48ba0b41f.zip";
    hash = "sha256-fJWxXI25nsxftSIdaNS/h1/OogKykZOYaFTLu/Mpvgs=";
    stripRoot = false;
  };
  discordIcon = "${discordIconSrc}/Discord_Symbol_Color/Discord-Symbol-Blurple.svg";
  colors = {
    con1 = "#ff6500";
    con2 = "#f420ed";
    con3 = "#00ffff";
  };
  coloredIcons = pkgs.runCommand "colored-discord-icons" { } ''
    mkdir -p $out
    ${lib.concatMapAttrsStringSep "\n" (name: color: ''
      cp ${discordIcon} $out/${name}.svg
      sed -i 's/#5865f2/${color}/g' $out/${name}.svg
    '') colors}
  '';
in
{
  options.pers.concord.enable = lib.mkEnableOption "concord";

  config = lib.mkIf config.pers.mpv.enable {
    home.packages = builtins.map (x: x.value) wrappers;

    xdg.configFile = builtins.listToAttrs (
      builtins.map (
        { name, ... }:
        {
          name = "concord/${name}/concord/config.toml";
          value = {
            text = ''
              [display]
              disable_image_preview = false
              show_avatars = true
              show_images = true
              image_preview_quality = "balanced"
              show_custom_emoji = true
              circular_avatars = false
              server_width = 20
              channel_list_width = 24
              member_list_width = 26
              emojis_as_links = false

              [notifications]
              desktop_notifications = true
              notification_icon = "${coloredIcons}/${name}.svg"

              [voice]
              self_mute = false
              self_deaf = false
              allow_microphone_transmit = false
              microphone_sensitivity = -30
              microphone_volume = 100
              voice_output_volume = 100

              [ui_state]
              collapsed_channel_categories = []
              collapsed_server_folder_ids = []
              collapsed_server_folder_guilds = []
            '';
          };
        }
      ) wrappers
    );

    xdg.desktopEntries = builtins.listToAttrs (
      builtins.map (
        { name, value }:
        {
          inherit name;
          value = {
            inherit name;
            genericName = "Discord Client";
            icon = "${coloredIcons}/${name}.svg";
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
