{
  lib,
  config,
  inputs,
  ...
}:

{
  imports = [ inputs.nixcord.homeManagerModules.nixcord ];

  options.pers.nixcord.enable = lib.mkEnableOption "nixcord";

  config = lib.mkIf config.pers.nixcord.enable {
    programs.nixcord = {
      enable = true;
      discord.enable = false;

      vesktop.enable = true;

      vesktop.settings = {
        discordBranch = "canary";
        minimizeToTray = false;
        tray = false;
        splashColor = "rgb(205, 214, 244)";
        splashBackground = "rgb(30, 30, 46)";
        splashTheming = true;
      };

      config = {
        frameless = true; # No bar at the top, using window manager
        transparent = true; # Requires a transparent theme

        # Example of how to enable a theme for future reference
        # enabledThemes = [ "stylix.theme.css" ];

        plugins = {
          anonymiseFileNames = {
            enable = true;
            anonymiseByDefault = true;
          };
          fixYoutubeEmbeds.enable = true;
          gifPaste.enable = true;
          memberCount.enable = true;
          messageLinkEmbeds.enable = true;
          noDevtoolsWarning.enable = true;
          normalizeMessageLinks.enable = true;
          permissionsViewer.enable = true;
          relationshipNotifier.enable = true;
          translate = {
            enable = true;
            autoTranslate = false;
            showChatBarButton = true;
          };
          validUser.enable = true;
          viewRaw.enable = true;
          webKeybinds.enable = true;
          webScreenShareFixes.enable = true;
          youtubeAdblock.enable = true;
        };
      };
    };
  };
}
