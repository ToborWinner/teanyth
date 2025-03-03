{
  lib,
  config,
  osConfig,
  pkgs,
  settings,
  ...
}:

{
  options.pers.mpd.enable = lib.mkEnableOption "mpd";

  config = lib.mkIf config.pers.mpd.enable {
    assertions = lib.singleton {
      assertion = osConfig.pers.pipewire.enable;
      message = "Pipewire must be enabled for mpd to be enabled.";
    };

    home.packages = with pkgs; [ mpc-cli ];

    services.mpd = {
      enable = true;
      musicDirectory = /home/${settings.username}/Music/music;
      playlistDirectory = /home/${settings.username}/Music/playlists;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };
  };
}
