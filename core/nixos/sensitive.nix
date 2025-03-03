{ lib, ... }:

with lib;

{
  options.sensitive = {
    timeZone = mkOption {
      type = types.str;
      description = "The timezone.";
    };

    kb_layout = mkOption {
      type = types.nullOr types.str;
      description = "Keyboard layout to use";
      default = null;
    };

    kb_variant = mkOption {
      type = types.nullOr types.str;
      description = "Keyboard variant to use";
      default = null;
    };

    kb_options = mkOption {
      type = types.nullOr types.str;
      description = "Keyboard options to use";
      default = null;
    };

    temporaryPasswordRpi = mkOption {
      type = types.nullOr types.str;
      description = "A temporary password for the rpi until I set up sops-nix on it";
      default = null;
    };
  };
}
