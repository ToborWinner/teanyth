{
  inputs,
  config,
  lib,
  ...
}:

{
  options.pers.wayland.enable = lib.mkEnableOption "wayland";

  config = lib.mkIf config.pers.wayland.enable {
    # Add binary caches
    nix.settings = {
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
    };

    nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];
  };
}
