{
  lib,
  config,
  inputs,
  settings,
  ...
}:

# Options automatically enabled by default in all configurations, such as using flakes
{
  options.pers.general.enable = lib.mkOption {
    default = true;
    description = "Whether to enable default general nix options";
    type = lib.types.bool;
  };

  config = lib.mkIf config.pers.general.enable {
    nix.registry = rec {
      nixpkgs.flake = inputs.nixpkgs;
      n = nixpkgs; # Abbreviation
      ${settings.username}.flake = inputs.self;
    };
    nix.channel.enable = false; # Disable nix-channel, we use flakes for declarative inputs
    nix.settings.flake-registry = ""; # Disable the global flake registry

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ]; # Enable flakes and new command line
      warn-dirty = false; # Remove the git dirty warning (we commit after rebuild, not before)
    };

    networking.firewall.enable = true;

    # I'll probably use the same keyboard settings on all machines
    pers.info = {
      kb_layout = config.sensitive.kb_layout;
      kb_variant = config.sensitive.kb_variant;
      kb_options = config.sensitive.kb_options;
    };
  };
}
