{
  lib,
  config,
  inputs,
  settings,
  sharedInfo,
  hostname,
  options,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.pers.home-manager = {
    enable = lib.mkEnableOption "home-manager";

    imports = lib.mkOption {
      description = "List of imports to include in the home-manager configuration";
      type = with lib.types; listOf deferredModule;
      default = [ ];
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      description = "State version to set in home manager";
      default = config.system.stateVersion;
    };
  };

  config = lib.mkIf config.pers.home-manager.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.${settings.username} =
      { ... }:
      {
        imports = config.pers.home-manager.imports;

        home.stateVersion = config.pers.home-manager.stateVersion;

        pers.isStandalone = lib.mkOverride 0 false;
      };
    home-manager.extraSpecialArgs = {
      inherit
        inputs
        settings
        sharedInfo
        hostname
        ;
      osOptions = options;
    };

    pers.home-manager.imports = lib.flatten [
      (inputs.sensitive + "/hm.nix")
      (import ../../core/hm)
      (import ../hm lib)
      (import ../../rices lib)
    ];
  };
}
