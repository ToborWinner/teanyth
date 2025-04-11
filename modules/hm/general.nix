{
  lib,
  config,
  inputs,
  osConfig,
  ...
}:

# This contains settings that are by default applied to all hosts with home manager
{
  options.pers = {
    isStandalone = lib.mkOption {
      type = lib.types.bool;
      default = true;
      internal = true;
      description = "Whether the current home configuration is a standalone installation";
    };

    general.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to enable the general personal options for home manager";
      default = true;
    };
  };

  config = lib.mkIf config.pers.general.enable {
    home.packages = [
      inputs.home-manager.packages.${osConfig.nixpkgs.hostPlatform.system}.home-manager
    ];

    xdg.enable = true; # Probably want this on most of the time

    # I don't see myself not using vi mode, so this is fine in general.nix
    home.file.".inputrc".text = ''
      set editing-mode vi
      set show-mode-in-prompt on
    '';

    # I'll probably always use the same keyboard settings between home-manager and NixOS
    pers.info = {
      kb_layout = osConfig.pers.info.kb_layout;
      kb_variant = osConfig.pers.info.kb_variant;
      kb_options = osConfig.pers.info.kb_options;
    };
  };
}
