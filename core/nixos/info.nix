{ config, lib, ... }:

with lib;

{
  options.pers.info = {
    getSecretFilePath = mkOption {
      type = with types; nullOr (functionTo str);
      description = "Function to get the path to a secret. Should be called with the secret name.";
      default = null;
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

    ifd = mkOption {
      type = types.attrsOf types.anything;
      description = "Import from derivation";
      default = { };
    };

    getIFD = mkOption {
      type = types.functionTo types.anything;
      description = "Function that takes a name as input and returns the output of the IFD";
      default = name: config.pers.info.ifd.${name};
    };
  };
}
